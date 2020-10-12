class PeakFlowUtils::NotifierErrorParser
  attr_reader :backtrace, :environment, :error, :file_path, :line_number

  def initialize(backtrace:, environment:, error:)
    @backtrace = backtrace
    @environment = environment || {}
    @error = error

    detect_file_path_and_line_number
  end

  def detect_file_path_and_line_number
    backtrace.each do |trace|
      match = trace.match(/^((.+)\.([A-z]{2,4})):(\d+)(:|$)/)
      next unless match

      file_path = match[1]
      line_number = match[4].to_i

      next if file_path.include?("/.rvm/")

      @file_path ||= file_path
      @line_number ||= line_number

      break
    end
  end

  def cleaned_environment
    environment.reject do |key, _value|
      key.start_with?("action_controller.") ||
        key.start_with?("action_dispatch.") ||
        key.start_with?("puma.") ||
        key.start_with?("rack.") ||
        key == "warden"
    end
  end

  def remote_ip
    environment["HTTP_X_FORWARDED_FOR"] || environment["REMOTE_ADDR"]
  end

  def url
    return unless environment["REQUEST_URI"]

    url = "http"
    url << "s" if environment["SERVER_PORT"] == 443 || environment["rack.url_scheme"] == "https" || environment["HTTPS"] == "on"
    url << "//"
    url << environment["HTTP_HOST"]
    url << environment["REQUEST_URI"]
    url
  end

  def user_agent
    environment["HTTP_USER_AGENT"]
  end
end
