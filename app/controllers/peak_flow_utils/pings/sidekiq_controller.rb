require "sidekiq/api"

class PeakFlowUtils::Pings::SidekiqController < PeakFlowUtils::ApplicationController
  def index
    sidekiq_queue = Sidekiq::Queue.new

    render json: {
      check_json_status: "OK",
      latency: sidekiq_queue.latency,
      queue_size: sidekiq_queue.size
    }
  end
end
