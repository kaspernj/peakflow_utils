class PeakFlowUtils::TranslationKey < PeakFlowUtils::ApplicationRecord
  has_many :handler_translations, dependent: :destroy
  has_many :translation_values, dependent: :destroy

  def last_key
    key.to_s.split(".").last
  end
end
