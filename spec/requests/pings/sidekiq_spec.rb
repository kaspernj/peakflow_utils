require "rails_helper"

describe "peak flow utils - postgres connections" do
  before do
    ENV["PEAKFLOW_PINGS_USERNAME"] = "test-pings"
    ENV["PEAKFLOW_PINGS_PASSWORD"] = "test-pings-password"
  end

  it "counts the number of live postgres connections" do
    headers = {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("test-pings", "test-pings-password")
    }

    get "/peak_flow_utils/pings/sidekiq", headers: headers

    result = response.parsed_body

    expect(result).to eq(
      "check_json_status" => "OK",
      "latency" => 0,
      "queue_size" => 0
    )
  end
end
