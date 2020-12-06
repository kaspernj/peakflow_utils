class PeakFlowUtils::Pings::PostgresConnectionsController < PeakFlowUtils::ApplicationController
  def count
    postgres_connections_count = ActiveRecord::Base.connection.execute("SELECT SUM(numbackends) AS connections_count FROM pg_stat_database").to_a.first

    render json: {
      check_json_status: "OK",
      postgres_connections_count: postgres_connections_count.fetch("connections_count")
    }
  end
end
