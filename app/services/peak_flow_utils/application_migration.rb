class PeakFlowUtils::ApplicationMigration < ActiveRecord::Migration[5.1]
  def self.connection
    PeakFlowUtils::ApplicationRecord.connection
  end
end
