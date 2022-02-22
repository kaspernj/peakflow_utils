class PeakFlowUtils::ActiveJobParametersLogging < PeakFlowUtils::ApplicationService
  def perform
    ActiveJob::Base.class_eval do
      around_perform do |job, block|
        PeakFlowUtils::Notifier.with_parameters(active_job: {job_name: job.class.name, job_arguments: job.arguments}) do
          block.call
        end
      end
    end
  end
end
