class PeakFlowUtils::NotifierRack
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    @app.call(env)
  rescue Exception => e
    PeakFlowUtils::Notifier.notify(environment: env, error: e)
  end
end
