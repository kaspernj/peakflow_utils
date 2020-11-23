require "rails_helper"

describe PeakFlowUtils::Notifier do
  let(:notifier) { PeakFlowUtils::Notifier.new(auth_token: "stub") }
  let(:sample_error) do
    error = nil

    begin
      raise "stub"
    rescue => e # rubocop:disable Style/RescueStandardError
      error = e
    end

    error
  end

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
        instance_double(
          Net::HTTPResponse,
          body: JSON.generate(
            url: "https://www.peakflow.io/something"
          ),
          code: 200
        )
      )

      response = notifier.notify(error: sample_error)

      expect(response.url).to eq "https://www.peakflow.io/something"
    end

    it "raises an error if peakflow rejects" do
      fake_response = instance_double(
        Net::HTTPResponse,
        body: JSON.generate(
          errors: ["Test error", "Another error"]
        ),
        code: 401
      )
      expect(fake_response).to receive(:[]).with("content-type").and_return("application/json")

      expect_any_instance_of(Net::HTTP).to receive(:request).and_return(fake_response)

      expect { notifier.notify(error: sample_error) }
        .to raise_error(
          PeakFlowUtils::Notifier::FailedToReportError,
          "Couldn't report error to Peakflow (code 401): Test error. Another error"
        )
    end
  end
end
