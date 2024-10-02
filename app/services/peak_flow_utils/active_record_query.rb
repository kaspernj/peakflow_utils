class PeakFlowUtils::ActiveRecordQuery
  class SlowSQLError < RuntimeError; end

  attr_reader :event

  def initialize(event)
    @event = event
  end

  def perform
    report_slow_sql if duration_seconds >= 3
  end

  def duration_seconds
    @duration_seconds ||= event.duration / 1000
  end

  def report_slow_sql
    PeakFlowUtils::Notifier.with_parameters(sql: sql, duration_seconds: duration_seconds) do
      raise SlowSQLError, "Slow SQL: #{sql_as_single_line}"
    rescue StandardError => e
      PeakFlowUtils::Notifier.notify(error: e)
    end
  end

  def sql
    @sql ||= event.payload.fetch(:sql)
  end

  def sql_as_single_line
    @sql_as_single_line ||= sql.tr("\n", " ")
  end
end
