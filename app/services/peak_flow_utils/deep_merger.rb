class PeakFlowUtils::DeepMerger < PeakFlowUtils::ApplicationService
  attr_reader :hashes, :object_mappings

  def initialize(hashes:, object_mappings: {})
    @hashes = hashes
    @object_mappings = object_mappings
  end

  def perform
    merged = {}

    hashes.each do |hash|
      merge_hash(hash, merged)
    end

    succeed! merged
  end

  def clone_something(object)
    if object.is_a?(Hash)
      new_hash = {}
      merge_hash(object, new_hash)
      new_hash
    elsif object.is_a?(Array)
      new_array = []
      merge_array(object, new_array)
      new_array
    else
      object
    end
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
      merged << clone_something(value)
    end
  end

  def merge_hash(hash, merged)
    hash.each do |key, value|
      if value.is_a?(Array)
        merged[key] = []
        merge_array(value, merged[key])
      elsif value.is_a?(Hash)
        merged[key] ||= {}
        merge_hash(value, merged[key])
      else
        merged[key] = clone_something(value)
      end
    end
  end
end
