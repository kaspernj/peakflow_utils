class PeakFlowUtils::DeepMerger < PeakFlowUtils::ApplicationService
  def initialize(hashes:)
    @hashes = hashes
  end

  def perform
    merged = {}

    @hashes.each do |hash|
      merge_hash(hash, merged)
    end

    succeed! merged
  end

  def merge_something(object, merged)
    if object.is_a?(Array)
      merge_array(object, merged)
    elsif object.is_a?(Hash)
      merge_hash(object, merged)
    else
      raise "Unknown object: #{object.class.name}"
    end
  end

  def merge_array(array, merged)
    array.each do |value|
      merged << value
    end
  end

  def merge_hash(hash, merged)
    hash.each do |key, value|
      if !merged.key?(key)
        merged[key] = value
      elsif value.is_a?(Array)
        merge_array(value, merged[key])
      elsif value.is_a?(Hash)
        merge_hash(value, merged[key])
      else
        raise "Unknown object: #{object.class.name}"
      end
    end
  end
end
