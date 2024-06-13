class PeakFlowUtils::ParseJson
  def initialize(object)
    @object = object
  end

  def parse
    parse_to_json(@object)
  end

  def active_record?(object)
    object.class.ancestors.any? do |ancestor|
      ancestor.name == "ActiveRecord::Base"
    end
  end

  def parse_to_json(object)
    if object.is_a?(Hash)
      result = {}

      object.each do |key, value|
        result[key] = parse_to_json(value)
      end

      return result
    elsif object.is_a?(Array)
      return object.map do |value|
        parse_to_json(value)
      end
    elsif active_record?(object)
      result = "#<#{object.class.name} id: #{object.id}"
      result << " name: \"#{object.name}\"" if object.respond_to?(:name)
      result << ">"

      return result
    end

    object
  end
end
