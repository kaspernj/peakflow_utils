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

  describe "#current_parameters" do
    it "registers parameters given through #with_parameters" do
      PeakFlowUtils::Notifier.with_parameters(people: [{first_name: "Kasper"}]) do
        PeakFlowUtils::Notifier.with_parameters(people: [{first_name: "Christina"}]) do
          parameters = PeakFlowUtils::Notifier.current_parameters

          expect(parameters).to eq(
            people: [
              {first_name: "Kasper"},
              {first_name: "Christina"}
            ]
          )
        end
      end
    end
  end

  describe "#notify" do
    it "raises an error if not configured" do
      expect { PeakFlowUtils::Notifier.notify(error: "something") }
        .to raise_error(PeakFlowUtils::Notifier::NotConfiguredError, "Hasn't been configured")
    end

    it "sends the error to the server" do
      expect_any_instance_of(Net::HTTP).to receive(:request) do |_https, request|
        # It sends the request with the expected body
        body = JSON.parse(request.body)

        expect(body).to match hash_including(
          "auth_token" => "stub",
          "error" => hash_including(
            "error_class" => "RuntimeError",
            "message" => "stub",
            "parameters" => {"people" => [{"first_name" => "Kasper"}]}
          )
        )

        # Use fake response in test
        instance_double(
          Net::HTTPResponse,
          body: JSON.generate(
            bug_report_id: 451,
            bug_report_instance_id: 452,
            project_id: 453,
            project_slug: "test-project",
            url: "https://www.peakflow.io/something"
          ),
          code: "200"
        )
      end

      response = nil

      PeakFlowUtils::Notifier.with_parameters(people: [{first_name: "Kasper"}]) do
        response = notifier.notify(error: sample_error)
      end

      expect(response).to have_attributes(
        bug_report_id: 451,
        bug_report_instance_id: 452,
        project_id: 453,
        project_slug: "test-project",
        url: "https://www.peakflow.io/something"
      )
    end

    it "raises an error if peakflow rejects" do
      fake_response = instance_double(
        Net::HTTPResponse,
        body: JSON.generate(
          errors: ["Test error", "Another error"]
        ),
        code: "401"
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
