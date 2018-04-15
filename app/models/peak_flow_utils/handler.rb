class PeakFlowUtils::Handler < PeakFlowUtils::ApplicationRecord
  has_many :groups, dependent: :destroy
  has_many :handler_texts, dependent: :destroy

  validates :name, presence: true

  def at_handler
    @at_handler ||= PeakFlowUtils::HandlerHelper.find(identifier)
  end

  def to_param
    identifier
  end
end
