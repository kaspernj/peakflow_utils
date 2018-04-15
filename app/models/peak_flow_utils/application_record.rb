class PeakFlowUtils::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = "peak_flow_utils_"

  def self.connection
    $peak_flow_utils_connection ||= ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: "db/peak_flow_utils.sqlite3"
    ).connection
  end
end
