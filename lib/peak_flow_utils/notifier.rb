class PeakFlowUtils::Notifier
  class FailedToReportError < RuntimeError; end
  class NotConfiguredError < RuntimeError; end

  attr_reader :auth_token

  def self.configure(auth_token:)
    @current = PeakFlowUtils::Notifier.new(auth_token: auth_token)
  end

  def self.current
    raise PeakFlowUtils::Notifier::NotConfiguredError, "Hasn't been configured" if !@current && Rails.env.test?

    @current
  end

  def self.notify(*args)
    PeakFlowUtils::Notifier.current.notify(*args)
  end

  def initialize(auth_token:)
    @auth_token = auth_token
  end

  def notify(error:, environment: nil, parameters: nil)
    error_parser = PeakFlowUtils::NotifierErrorParser.new(
      backtrace: error.backtrace,
      environment: environment,
      error: error
    )

    uri = URI("https://www.peakflow.io/errors/reports")

    https = Net::HTTP.new(uri.host, uri.port)
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
        parameters: parameters,
        remote_ip: error_parser.remote_ip,
        url: error_parser.url,
        user_agent: error_parser.user_agent
      }
    }

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request.body = JSON.generate(data)

    response = https.request(request)

    raise FailedToReportError, error_message_from_response(response) unless response.code == "200"

    response_data = JSON.parse(response.body)

    # Data not always present so dont use fetch
    PeakFlowUtils::NotifierResponse.new(
      bug_report_id: response_data["bug_report_id"],
      bug_report_instance_id: response_data["bug_report_instance_id"],
      project_id: response_data["project_id"],
      project_slug: response_data["project_slug"],
      url: response_data["url"]
    )
  end

  def error_message_from_response(response)
    message = "Couldn't report error to Peakflow (code #{response.code})"

    if response["content-type"]&.starts_with?("application/json")
      response_data = JSON.parse(response.body)
      message << ": #{response_data.fetch("errors").join(". ")}" if response_data["errors"]
    end

    message
  end
end
