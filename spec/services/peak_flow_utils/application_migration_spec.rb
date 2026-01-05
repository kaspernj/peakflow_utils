require "rails_helper"

describe PeakFlowUtils::ApplicationMigration do
  describe "#connection" do
    it "uses the application record connection" do
      expect(described_class.new.connection).to eq(PeakFlowUtils::ApplicationRecord.connection)
    end
  end
end
