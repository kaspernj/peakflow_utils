require "rails_helper"

describe "notifier rack" do
  it "reports the error with query and post parameters" do
    expect(PeakFlowUtils::Notifier).to receive(:notify).with(
      environment: instance_of(Hash),
      error: instance_of(RuntimeError),
      parameters: {
        "first_name" => "Kasper",
        "last_name" => "Stöckel"
      }
    )

    expect do
      post action_error_notifier_errors_path(first_name: "Kasper"), params: {last_name: "Stöckel"}
    end.to raise_error(RuntimeError)
  end

  it "reports the error with query and json post parameters" do
    expect(PeakFlowUtils::Notifier).to receive(:notify).with(
      environment: instance_of(Hash),
      error: instance_of(RuntimeError),
      parameters: {
        "first_name" => "Kasper",
        "last_name" => "Stöckel",
        "notifier_error" => {
          "last_name" => "Stöckel"
        }
      }
    )

    expect do
      post action_error_notifier_errors_path(first_name: "Kasper"), headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(last_name: "Stöckel")
    end.to raise_error(RuntimeError)
  end
end
