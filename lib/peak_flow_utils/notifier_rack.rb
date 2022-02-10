class PeakFlowUtils::NotifierRack
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    @app.call(env)
  rescue Exception => e # rubocop:disable Lint/RescueException
    controller = env["action_controller.instance"]
    request = controller&.request

    PeakFlowUtils::Notifier.with_parameters(rack: {get: request.GET, post: request.POST}) do
      PeakFlowUtils::Notifier.notify(
        environment: env,
        error: e
      )
    end

    raise e
  end
end
