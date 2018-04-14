namespace :peak_flow_utils do
  task "parse_translations" => :environment do
    PeakFlowUtils::TranslationsParserService.execute!
    raise "stub"
  end
end
