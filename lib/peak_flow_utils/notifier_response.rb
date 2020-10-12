class PeakFlowUtils::NotifierResponse
  attr_reader :url

  def initialize(url:)
    @url = url
  end
end
