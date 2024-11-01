require_relative "peak_flow_utils/engine"

require "array_enumerator"
require "service_pattern"

module PeakFlowUtils
  path = "#{__dir__}/peak_flow_utils"
  models_path = "#{__dir__}/peak_flow_utils/models"
  services_path = File.realpath("#{__dir__}/../app/services/peak_flow_utils")

  autoload :InheritedLocalVar, "#{path}/inherited_local_var"
  autoload :Notifier, "#{path}/notifier"
  autoload :NotifierActiveRecord, "#{path}/notifier_active_record"
  autoload :NotifierErrorParser, "#{path}/notifier_error_parser"
  autoload :NotifierRack, "#{path}/notifier_rack"
  autoload :NotifierRails, "#{path}/notifier_rails"
  autoload :NotifierResponse, "#{path}/notifier_response"
  autoload :NotifierSidekiq, "#{path}/notifier_sidekiq"
  autoload :HandlerHelper, "#{path}/handler_helper"
  autoload :ParseJson, "#{path}/parse_json"

  autoload :ApplicationRecord, "#{models_path}/application_record"
  autoload :Group, "#{models_path}/group"
  autoload :HandlerText, "#{models_path}/handler_text"
  autoload :Handler, "#{models_path}/handler"
  autoload :ScannedFile, "#{models_path}/scanned_file"
  autoload :TranslationKey, "#{models_path}/translation_key"
  autoload :TranslationValue, "#{models_path}/translation_value"

  autoload :ActiveJobParametersLogging, "#{services_path}/active_job_parameters_logging"
  autoload :ApplicationService, "#{services_path}/application_service"
  autoload :SidekiqParametersLogging, "#{services_path}/sidekiq_parameters_logging"
  autoload :DeepMerger, "#{services_path}/deep_merger"
end
