class PeakFlowUtils::Group < PeakFlowUtils::ApplicationRecord
  attr_writer :at_group

  belongs_to :handler, class_name: "PeakFlowUtils::Handler"

  has_many :handler_translations, dependent: :destroy, foreign_key: "group_id", class_name: "PeakFlowUtils::HandlerTranslation"
  has_many :translation_keys, dependent: :destroy, foreign_key: "group_id", class_name: "PeakFlowUtils::TranslationKey"

  validates_presence_of :name, :handler

  def at_handler
    @at_handler ||= handler.at_handler
  end

  def at_group
    @at_group ||= PeakFlowUtils::GroupService.find_by_handler_and_id(at_handler, identifier)
  end

  def to_param
    identifier
  end
end
