require "rails_helper"

describe "peak flow utils - postgres connections" do
  before do
    ENV["PEAKFLOW_PINGS_USERNAME"] = "test-pings"
    ENV["PEAKFLOW_PINGS_PASSWORD"] = "test-pings-password"
  end

  it "counts the number of live postgres connections" do
    expect_any_instance_of(ActiveRecord::ConnectionAdapters::SQLite3Adapter).to receive(:execute).and_return(
      [
        {
          "connections_count" => 5
        }
      ]
    )

    headers = {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("test-pings", "test-pings-password")
    }

    get "/peak_flow_utils/pings/postgres_connections", headers: headers

    result = JSON.parse(response.body)
    connections_count = result.fetch("postgres_connections_count")

    expect(connections_count).to eq 5
  end
end
