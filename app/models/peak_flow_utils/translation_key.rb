class PeakFlowUtils::TranslationKey < PeakFlowUtils::ApplicationRecord
  has_many :handler_translations,
    dependent: :destroy,
    foreign_key: "translation_key_id",
    class_name: "PeakFlowUtils::HandlerText"

  has_many :translation_values,
    dependent: :destroy,
    foreign_key: "translation_key_id",
    class_name: "PeakFlowUtils::TranslationValue"

  def last_key
    key.to_s.split(".").last
  end
end
