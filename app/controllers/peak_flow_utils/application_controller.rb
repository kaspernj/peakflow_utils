class PeakFlowUtils::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate

private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch("PEAK_FLOW_PINGS_USERNAME") && password == ENV.fetch("PEAK_FLOW_PINGS_PASSWORD")
    end
  end
end
