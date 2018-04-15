class PeakFlowUtils::ConfigurationService
  attr_accessor :paths_to_translate

  def self.current
    @current ||= PeakFlowUtils::ConfigurationService.new
  end

  def initialize
    @paths_to_translate = [Rails.root.to_s]
  end
end
