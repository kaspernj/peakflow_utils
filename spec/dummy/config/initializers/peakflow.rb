require "peak_flow_utils"

PeakFlowUtils::Notifier.configure(auth_token: "test-token")
PeakFlowUtils::Notifier.current.on_notify do |parameters:|
  parameters[:extra_param] = "test"
end

PeakFlowUtils::NotifierRails.configure
PeakFlowUtils::NotifierSidekiq.configure
