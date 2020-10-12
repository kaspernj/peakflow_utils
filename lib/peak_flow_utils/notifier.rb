class PeakFlowUtils::Notifier
  attr_reader :auth_token

  def self.configure(auth_token:)
    @current = PeakFlowUtils::Notifier.new(auth_token: auth_token)
  end

  def self.current
    raise "No current notifier has been set" unless @current
    @current
  end

  def self.notify(error:, data: nil, environment: nil)
    PeakFlowUtils::Notifier.current.notify(data: data, error: error)
  end

  def initialize(auth_token:)
    @auth_token = auth_token
  end

  def notify(error:, data: nil, environment: nil)
    uri = URI("https://www.peakflow.io/errors/reports")

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    data = {
      auth_token: auth_token,
      error: {
        backtrace: error.backtrace,
        environment: environment,
        error_class: error.class.name,
        file_path: nil,
        line_number: nil,
        message: error.message,
        parameters: nil,
        remote_ip: nil,
        url: nil,
        user_agent: nil
      }
    }

    request = Net::HTTP::Post.new(uri.path)
    request["Content-Type"] = "application/json"
    request.body = JSON.generate(data)

    response = https.request(request)
    response_data = JSON.parse(response.body)

    PeakFlowUtils::NotifierResponse.new(url: response_data.fetch("url"))
  end
end
