require "rails_helper"

describe PeakFlowUtils::TranslationsParserService do
  describe "#execute!" do
    it "starts parsing translations" do
      PeakFlowUtils::TranslationsParserService.execute!
    end
  end
end
