require "peak_flow_utils"

PeakFlowUtils::Notifier.configure(auth_token: "stub")
PeakFlowUtils::NotifierRails.configure
PeakFlowUtils::NotifierSidekiq.configure
