require "rails_helper"

describe "notifier rack" do
  before do
    PeakFlowUtils::Notifier.reset_parameters
    set_notifier_configuration
  end

  def set_notifier_configuration
    PeakFlowUtils::Notifier.configure(auth_token: "test-token") unless PeakFlowUtils::Notifier.instance_variable_get(:@current)
  end

  it "reports the error with query and post parameters" do
    expect(PeakFlowUtils::Notifier)
      .to receive(:notify).with(
        environment: instance_of(Hash),
        error: instance_of(RuntimeError)
      )
      .and_call_original

    expect(PeakFlowUtils::Notifier)
      .to receive(:with_parameters).with(
        rack: {
          get: {
            "first_name" => "Kasper"
          },
          post: {
            "last_name" => "Stöckel"
          }
        }
      )
      .and_call_original

    expect_any_instance_of(PeakFlowUtils::Notifier)
      .to receive(:send_notify_request).with(
        data: {
          auth_token: "test-token",
          error: hash_including(
            backtrace: instance_of(Array),
            error_class: "RuntimeError",
            parameters: {
              rack: {
                get: {"first_name" => "Kasper"},
                post: {"last_name" => "Stöckel"}
              },
              extra_param: "test"
            },
            remote_ip: "127.0.0.1",
            url: "http://www.example.com/notifier_errors/action_error?first_name=Kasper"
          )
        },
        uri: instance_of(URI::HTTPS)
      )

    expect { post action_error_notifier_errors_path(first_name: "Kasper"), params: {last_name: "Stöckel"} }
      .to raise_error(RuntimeError)
  end

  it "reports the error with query and json post parameters" do
    expect(PeakFlowUtils::Notifier).to receive(:notify).with(
      environment: instance_of(Hash),
      error: instance_of(RuntimeError)
    )
    expect(PeakFlowUtils::Notifier)
      .to receive(:with_parameters).with(
        rack: {
          get: {
            "first_name" => "Kasper"
          },
          post: {
            "last_name" => "Stöckel",
            "notifier_error" => {
              "last_name" => "Stöckel"
            }
          }
        }
      )
      .and_call_original

    expect do
      post action_error_notifier_errors_path(first_name: "Kasper"), headers: {"CONTENT_TYPE" => "application/json"}, params: JSON.generate(last_name: "Stöckel")
    end.to raise_error(RuntimeError)
  end
end
