require "rails_helper"

describe PeakFlowUtils::ActiveRecordQuery do
  let(:event) { instance_double(ActiveSupport::Notifications::Event, duration: 3500, payload: {sql: "SELECT * FROM users"}) }
  let(:service) { PeakFlowUtils::ActiveRecordQuery.new(event) }

  it "reports an error for slow SQL" do
    expect(PeakFlowUtils::Notifier).to receive(:notify).with(error: instance_of(PeakFlowUtils::ActiveRecordQuery::SlowSQLError))

    service.perform
  end
end
