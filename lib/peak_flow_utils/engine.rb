require "rails"

module PeakFlowUtils; end

class PeakFlowUtils::Engine < Rails::Engine # rubocop:disable Style/OneClassPerFile
  isolate_namespace PeakFlowUtils
end
