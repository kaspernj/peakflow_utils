class PeakFlowUtils::Group < PeakFlowUtils::ApplicationRecord
  attr_writer :at_group

  belongs_to :handler

  has_many :handler_translations, dependent: :destroy
  has_many :translation_keys, dependent: :destroy

  validates :name, presence: true

  def at_handler
    @at_handler ||= handler.at_handler
  end

  def at_group
    @at_group ||= PeakFlowUtils::GroupService.find_by_handler_and_id(at_handler, identifier) # rubocop:disable Rails/DynamicFindBy
  end

  def to_param
    identifier
  end
end
