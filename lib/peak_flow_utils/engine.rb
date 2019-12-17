require "rails"

module PeakFlowUtils; end

class PeakFlowUtils::Engine < ::Rails::Engine
  isolate_namespace PeakFlowUtils
end
