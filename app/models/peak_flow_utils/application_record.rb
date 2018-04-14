class PeakFlowUtils::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  establish_connection "peak_flow_utils"
end
