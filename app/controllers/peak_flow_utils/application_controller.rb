class PeakFlowUtils::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate

private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      if ENV["PEAKFLOW_PINGS_USERNAME"].blank? || ENV["PEAKFLOW_PINGS_PASSWORD"].blank?
        Rails.logger.error "Peakflow utils: Pings called but PEAKFLOW_PINGS_USERNAME or PEAKFLOW_PINGS_PASSWORD wasn't set"
        return false
      end

      username == ENV.fetch("PEAKFLOW_PINGS_USERNAME") && password == ENV.fetch("PEAKFLOW_PINGS_PASSWORD")
    end
  end
end
