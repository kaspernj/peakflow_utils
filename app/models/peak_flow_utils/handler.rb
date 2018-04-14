class PeakFlowUtils::Handler < PeakFlowUtils::ApplicationRecord
  establish_connection "peak_flow_utils"

  has_many :groups, dependent: :destroy, foreign_key: "handler_id", class_name: "PeakFlowUtils::Group"
  has_many :handler_translations, dependent: :destroy, foreign_key: "handler_id", class_name: "PeakFlowUtils::HandlerTranslation"

  validates_presence_of :name

  def at_handler
    @at_handler ||= PeakFlowUtils::Handler.find(identifier)
  end

  def to_param
    identifier
  end
end
