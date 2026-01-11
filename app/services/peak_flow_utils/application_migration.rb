class PeakFlowUtils::ApplicationMigration < ActiveRecord::Migration[5.1]
  def connection(*, &)
    PeakFlowUtils::ApplicationRecord.connection(*, &)
  end
end
