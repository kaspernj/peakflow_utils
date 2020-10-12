class PeakFlowUtils::Pings::SidekiqPingsController < PeakFlowUtils::ApplicationController
  def create
    sidekiq_queue = Sidekiq::Queue.new

    render json: {
      latency: sidekiq_queue.latency,
      queue_size: sidekiq_queue.size
    }
  end
end
