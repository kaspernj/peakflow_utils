class PeakFlowUtils::NotifierActiveRecord
  def self.configure
    ActiveSupport::Notifications.subscribe("sql.active_record") do |*args|
      event = ActiveSupport::Notifications::Event.new(*args)
      PeakFlowUtils::ActiveRecordQuery.new(event).perform
    end
  end
end
