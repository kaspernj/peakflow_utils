require "rails_helper"

describe PeakFlowUtils::Notifier do
  let(:notifier) { PeakFlowUtils::Notifier.new(auth_token: "stub") }

  describe "#notify" do
    it "sends the error to the server" do
      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(
        double( # rubocop:disable RSpec/VerifiedDoubles
          body: JSON.generate(
            url: "https://www.peakflow.io/something"
          )
        )
      )

      error = nil

      begin
        raise "stub"
      rescue => e # rubocop:disable Style/RescueStandardError
        error = e
      end

      response = notifier.notify(error: error)

      expect(response.url).to eq "https://www.peakflow.io/something"
    end
  end
end
