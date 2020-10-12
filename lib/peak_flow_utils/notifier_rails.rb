class PeakFlowUtils::NotifierRails
  def self.configure
    Rails.application.config.app_middleware.use PeakFlowUtils::NotifierRack
  end
end
