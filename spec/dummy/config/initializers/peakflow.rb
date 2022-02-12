require "peak_flow_utils"

PeakFlowUtils::Notifier.configure(auth_token: "test-token")
PeakFlowUtils::NotifierRails.configure
PeakFlowUtils::NotifierSidekiq.configure
