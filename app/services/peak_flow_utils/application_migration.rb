class PeakFlowUtils::ApplicationMigration < ActiveRecord::Migration[5.1]
  delegate :connection, to: PeakFlowUtils::ApplicationRecord
end
