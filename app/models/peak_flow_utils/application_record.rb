class PeakFlowUtils::ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  establish_connection(
    adapter: "sqlite3",
    database: "db/peak_flow_utils.sqlite3"
  )
end
