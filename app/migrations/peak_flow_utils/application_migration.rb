class PeakFlowUtils::ApplicationMigration < ActiveRecord::Migration[5.1]
  def connection
    ActiveRecord::Base.establish_connection("peak_flow_utils").connection
  end
end
