class PeakFlowUtils::HandlerHelper
  delegate :translations, to: :instance

  def self.find(id)
    PeakFlowUtils::HandlersFinderService.execute!.each do |handler|
      return handler if handler.id == id.to_s
    end

    raise ActiveRecord::RecordNotFound, "Handlers not found: '#{id}'."
  end

  def initialize(data)
    @data = data
  end

  def id
    @data.fetch(:id)
  end

  def to_param
    id
  end

  def name
    @data.fetch(:name)
  end

  def const
    PeakFlowUtils.const_get(@data.fetch(:const_name))
  end

  def instance
    const.new
  end

  def groups
    const.new.groups
  end
end
