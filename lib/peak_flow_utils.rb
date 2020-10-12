require_relative "peak_flow_utils/engine"

require "array_enumerator"
require "service_pattern"

module PeakFlowUtils
  path = "#{File.dirname(__FILE__)}/peak_flow_utils"

  autoload :Notifier, "#{path}/notifier"
  autoload :NotifierErrorParser, "#{path}/notifier_error_parser"
  autoload :NotifierRack, "#{path}/notifier_rack"
  autoload :NotifierRails, "#{path}/notifier_rails"
  autoload :NotifierResponse, "#{path}/notifier_response"
  autoload :NotifierSidekiq, "#{path}/notifier_sidekiq"
  autoload :RspecHelper, "#{path}/rspec_helper"
  autoload :HandlerHelper, "#{path}/handler_helper"
end
