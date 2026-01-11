require "rails_helper"

describe PeakFlowUtils::TranslationsParserService do
  describe "#execute!" do
    it "starts parsing translations" do
      expect { PeakFlowUtils::TranslationsParserService.execute! }.not_to raise_error
    end
  end
end
