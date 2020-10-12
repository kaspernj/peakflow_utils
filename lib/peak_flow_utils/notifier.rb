class PeakFlowUtils::Notifier
  def self.configure(token:)
    @current = PeakFlowUtils::Notifier.new(token: token)
  end

  def self.current
    raise "No current notifier has been set" unless @current
    @current
  end

  def self.notify(error:, data: nil, environment: nil)
    PeakFlowUtils.current.notify(data: data, error: error)
  end

  def initialize(token:)
    @token = token
  end

  def notify(error:, data: nil, environment: nil)
    raise "stub"
  end
end
