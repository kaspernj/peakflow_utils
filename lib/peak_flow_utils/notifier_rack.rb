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
    parameters = request.GET.merge(request.POST)

    PeakFlowUtils::Notifier.notify(
      environment: env,
      error: e,
      parameters: parameters
    )

    raise e
  end
end
