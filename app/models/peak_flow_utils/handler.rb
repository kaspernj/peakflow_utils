class PeakFlowUtils::Handler < PeakFlowUtils::ApplicationRecord
  has_many :groups, dependent: :destroy, foreign_key: "handler_id", class_name: "PeakFlowUtils::Group"
  has_many :handler_translations, dependent: :destroy, foreign_key: "handler_id", class_name: "PeakFlowUtils::HandlerText"

  validates_presence_of :name

  def at_handler
    @at_handler ||= PeakFlowUtils::HandlerHelper.find(identifier)
  end

  def to_param
    identifier
  end
end
