class PeakFlowUtils::HandlersFinderService < PeakFlowUtils::ApplicationService
  def execute!
    handlers = []

    Dir.foreach("#{File.dirname(__FILE__)}/../../handlers/peak_flow_utils") do |file|
      match = file.match(/\A(.+)_handler\.rb\Z/)
      next unless match

      const_name_snake = "#{match[1]}_handler"
      next if const_name_snake == "application_handler"

      const_name_camel = const_name_snake.camelize

      handler = PeakFlowUtils::HandlerHelper.new(
        id: const_name_snake,
        const_name: const_name_camel,
        name: const_name_camel
      )

      handlers << handler if handler.instance.enabled?
    end

    ServicePattern::Response.new(result: handlers)
  end
end
