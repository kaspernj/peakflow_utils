Rails.application.routes.draw do
  mount PeakFlowUtils::Engine => "/peak_flow_utils"
end
