require "rails_helper"

describe PeakFlowUtils::Notifier do
  let(:notifier) { PeakFlowUtils::Notifier.new(auth_token: "stub") }

  before { reset_notifier_configuration }

  after { reset_notifier_configuration }

  def reset_notifier_configuration
    PeakFlowUtils::Notifier.instance_variable_set(:@current, nil)
  end

  describe "#configure" do
    it "sets the current notifier" do
      PeakFlowUtils::Notifier.configure(auth_token: "test-token")

      expect(PeakFlowUtils::Notifier.current.auth_token).to eq "test-token"
    end
  end

  describe "#current" do
    it "raises an error if it isn't been configured" do
      expect { PeakFlowUtils::Notifier.current }
        .to raise_error(PeakFlowUtils::Notifier::NotConfiguredError, "Hasn't been configured")
    end
  end

  describe "#notify" do
    it "raises an error if not configured" do
      expect { PeakFlowUtils::Notifier.notify(error: "something") }
        .to raise_error(PeakFlowUtils::Notifier::NotConfiguredError, "Hasn't been configured")
    end

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
