class PeakFlowUtils::NotifierSidekiq
  def self.configure
    require "sidekiq"

    Sidekiq.configure_server do |config|
      config.error_handlers << proc do |error, context|
        PeakFlowUtils::Notifier.notify(error: error, data: {sidekiq: context})
      end
    end
  end
end
