require_relative "peak_flow_utils/engine"

require "array_enumerator"
require "service_pattern"

module PeakFlowUtils
  path = "#{__dir__}/peak_flow_utils"
  models_path = "#{__dir__}/peak_flow_utils/models"

  autoload :InheritedLocalVar, "#{path}/inherited_local_var"
  autoload :Notifier, "#{path}/notifier"
  autoload :NotifierErrorParser, "#{path}/notifier_error_parser"
  autoload :NotifierRack, "#{path}/notifier_rack"
  autoload :NotifierRails, "#{path}/notifier_rails"
  autoload :NotifierResponse, "#{path}/notifier_response"
  autoload :NotifierSidekiq, "#{path}/notifier_sidekiq"
  autoload :HandlerHelper, "#{path}/handler_helper"

  autoload :ApplicationRecord, "#{models_path}/application_record"
  autoload :Group, "#{models_path}/group"
  autoload :HandlerText, "#{models_path}/handler_text"
  autoload :Handler, "#{models_path}/handler"
  autoload :ScannedFile, "#{models_path}/scanned_file"
  autoload :TranslationKey, "#{models_path}/translation_key"
  autoload :TranslationValue, "#{models_path}/translation_value"
end
