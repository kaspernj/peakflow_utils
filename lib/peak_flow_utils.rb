require_relative "peak_flow_utils/engine"

require "array_enumerator"
require "service_pattern"

module PeakFlowUtils
  path = "#{File.dirname(__FILE__)}/peak_flow_utils"

  autoload :RspecHelper, "#{path}/rspec_helper"
  autoload :HandlerHelper, "#{path}/handler_helper"
end
