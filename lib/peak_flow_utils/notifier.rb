class PeakFlowUtils::Notifier
  class FailedToReportError < RuntimeError; end
  class NotConfiguredError < RuntimeError; end

  attr_reader :auth_token, :mutex, :parameters

  def self.configure(auth_token:)
    @current = PeakFlowUtils::Notifier.new(auth_token: auth_token)
  end

  def self.current # rubocop:disable Style/TrivialAccessors
    @current
  end

  def self.notify(*args, **opts, &blk)
    PeakFlowUtils::Notifier.current.notify(*args, **opts, &blk)
  end

  def self.reset_parameters
    ::PeakFlowUtils::Notifier.current.instance_variable_set(:@parameters, ::PeakFlowUtils::InheritedLocalVar.new({}))
  end

  def self.with_parameters(parameters)
    random_id = ::SecureRandom.hex(16)

    ::PeakFlowUtils::Notifier.current.mutex.synchronize do
      raise "'parameters' was nil?" if ::PeakFlowUtils::Notifier.current.parameters.value.nil?

      parameters_with = ::PeakFlowUtils::Notifier.current.parameters.value.clone
      parameters_with[random_id] = parameters

      ::PeakFlowUtils::Notifier.current.parameters.value = parameters_with
    end

    begin
      yield
    ensure
      ::PeakFlowUtils::Notifier.current.mutex.synchronize do
        parameters_without = ::PeakFlowUtils::Notifier.current.parameters.value.clone
        parameters_without.delete(random_id)

        ::PeakFlowUtils::Notifier.current.parameters.value = parameters_without
      end
    end
  end

  def initialize(auth_token:)
    @auth_token = auth_token
    @mutex = ::Mutex.new
    @parameters = ::PeakFlowUtils::InheritedLocalVar.new({})
  end

  def current_parameters(parameters: nil)
    hashes = current_parameters_hashes
    hashes << parameters if parameters

    ::PeakFlowUtils::DeepMerger.execute!(hashes: hashes)
  end

  def current_parameters_hashes
    parameters.value.values
  end

  def error_message_from_response(response)
    message = "Couldn't report error to Peakflow (code #{response.code})"

    if response["content-type"]&.starts_with?("application/json")
      response_data = ::JSON.parse(response.body)
      message << ": #{response_data.fetch("errors").join(". ")}" if response_data["errors"]
    end

    message
  end

  def notify(error:, environment: nil, parameters: nil)
    error_parser = ::PeakFlowUtils::NotifierErrorParser.new(
      backtrace: error.backtrace,
      environment: environment,
      error: error
    )

    merged_parameters = current_parameters(parameters: parameters)

    uri = URI("https://www.peakflow.io/errors/reports")

    https = ::Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    data = {
      auth_token: auth_token,
      error: {
        backtrace: error.backtrace,
        environment: error_parser.cleaned_environment,
        error_class: error.class.name,
        file_path: error_parser.file_path,
        line_number: error_parser.line_number,
        message: error.message,
        parameters: merged_parameters,
        remote_ip: error_parser.remote_ip,
        url: error_parser.url,
        user_agent: error_parser.user_agent
      }
    }

    request = ::Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request.body = ::JSON.generate(data)

    response = https.request(request)

    raise FailedToReportError, error_message_from_response(response) unless response.code == "200"

    response_data = ::JSON.parse(response.body)

    # Data not always present so dont use fetch
    ::PeakFlowUtils::NotifierResponse.new(
      bug_report_id: response_data["bug_report_id"],
      bug_report_instance_id: response_data["bug_report_instance_id"],
      project_id: response_data["project_id"],
      project_slug: response_data["project_slug"],
      url: response_data["url"]
    )
  end
end
