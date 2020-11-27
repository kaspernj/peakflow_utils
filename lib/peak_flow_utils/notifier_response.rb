class PeakFlowUtils::NotifierResponse
  attr_reader :bug_report_id, :bug_report_instance_id, :project_id, :project_slug, :url

  def initialize(bug_report_id:, bug_report_instance_id:, project_id:, project_slug:, url:)
    @bug_report_id = bug_report_id
    @bug_report_instance_id = bug_report_instance_id
    @project_id = project_id
    @project_slug = project_slug
    @url = url
  end
end
