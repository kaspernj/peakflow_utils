class PeakFlowUtils::TranslationValue < PeakFlowUtils::ApplicationRecord
  belongs_to :translation_key


  delegate :key, to: :translation_key

  def calculated_translation_file_path
    "#{handler_translation.dir}/#{locale}.yml" if handler_translation
  end

  def handler_translation
    return @handler_translation if defined?(@handler_translation)

    @handler_translation = PeakFlowUtils::HandlerText
      .find_by(translation_key_id: translation_key_id)
  end

  def migrate_to_awesome_translations_namespace!
    PeakFlowUtils::TranslationMigrator.new(
      translation_key: translation_key,
      handler_translation: handler_translation,
      translation_value: self
    ).execute
  end
end
