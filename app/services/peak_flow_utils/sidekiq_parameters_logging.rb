class PeakFlowUtils::SidekiqParametersLogging < PeakFlowUtils::ApplicationService
  def perform
    require "sidekiq"
    require "sidekiq/processor"

    Sidekiq::Processor.class_eval do
      def execute_job(worker, cloned_args)
        PeakFlowUtils::Notifier.with_parameters(sidekiq: {worker_class_name: worker.class.name, cloned_args: cloned_args}) do
          worker.perform(*cloned_args)
        end
      end
    end

    succeed!
  end
end
