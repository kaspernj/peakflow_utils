require "rails_helper"

describe PeakFlowUtils::Notifier do
  let(:notifier) { PeakFlowUtils::Notifier.current }
  let(:sample_error) do
    error = nil

    begin
      raise "stub"
    rescue => e # rubocop:disable Style/RescueStandardError
      error = e
    end

    error
  end

  before do
    set_notifier_configuration
    PeakFlowUtils::Notifier.reset_parameters
  end

  def set_notifier_configuration
    PeakFlowUtils::Notifier.configure(auth_token: "test-token") unless PeakFlowUtils::Notifier.instance_variable_get(:@current)
  end

  describe "#configure" do
    it "sets the current notifier" do
      expect(PeakFlowUtils::Notifier.current.auth_token).to eq "test-token"
    end
  end

  describe "#current_parameters" do
    it "registers parameters given through #with_parameters" do
      PeakFlowUtils::Notifier.with_parameters(people: {kasper: {first_name: "Kasper"}}) do
        PeakFlowUtils::Notifier.with_parameters(people: {christina: {first_name: "Christina"}}) do
          parameters = notifier.current_parameters

          expect(parameters).to eq(
            people: {
              kasper: {first_name: "Kasper"},
              christina: {first_name: "Christina"}
            }
          )
        end
      end
    end
  end

  describe "#notify" do
    it "sends the error to the server" do
      expect_any_instance_of(Net::HTTP).to receive(:request) do |_https, request|
        # It sends the request with the expected body
        body = JSON.parse(request.body)

        expect(body).to match hash_including(
          "auth_token" => "test-token",
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

      expect(PeakFlowUtils::Notifier.current.parameters.value).to eq({})

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

    it "#notify_message" do
      expect(PeakFlowUtils::Notifier.current).to receive(:notify) do |error:|
        expect(error.message).to eq "test"
        expect(error).to be_an_instance_of(PeakFlowUtils::Notifier::NotifyMessageError)
      end

      PeakFlowUtils::Notifier.notify_message("test")
    end

    it "remembers parameters across threads" do
      parameters = nil

      PeakFlowUtils::Notifier.with_parameters(birds: {ducks: {donald: {name: "Donald"}}}) do
        expect(notifier.current_parameters).to eq(birds: {ducks: {donald: {name: "Donald"}}})

        Thread
          .new do
            Thread
              .new do
                expect(notifier.current_parameters).to eq(birds: {ducks: {donald: {name: "Donald"}}})

                PeakFlowUtils::Notifier.with_parameters(birds: {ducks: {daisy: {name: "Daisy"}}}) do
                  expect(notifier.current_parameters).to eq(birds: {ducks: {donald: {name: "Donald"}, daisy: {name: "Daisy"}}})

                  parameters = notifier.current_parameters
                end
              end
              .join
          end
          .join
      end

      expect(parameters).to eq(
        birds: {
          ducks: {
            donald: {name: "Donald"},
            daisy: {name: "Daisy"}
          }
        }
      )
    end
  end
end
