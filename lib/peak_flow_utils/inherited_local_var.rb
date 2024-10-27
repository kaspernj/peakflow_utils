require "monitor"
require_relative "thread_callbacks_patch"

Thread.on_initialize do |parent:, thread:|
  parent_vars = parent.instance_variable_get(:@_inherited_local_vars)
  new_cloned_vars = PeakFlowUtils::DeepMerger.execute!(hashes: [parent_vars])
  thread.instance_variable_set(:@_inherited_local_vars, new_cloned_vars)
end

Thread.class_eval do
  def self.inherited_local_vars_mutex
    @inherited_local_vars_mutex ||= Mutex.new
  end

  def self._inherited_local_vars
    Thread.current.instance_variable_set(:@_inherited_local_vars, {}) unless Thread.current.instance_variable_get(:@_inherited_local_vars)
    Thread.current.instance_variable_get(:@_inherited_local_vars)
  end

  def self.inherited_local_vars_reset
    ObjectSpace.each_object(Thread) do |thread|
      inherited_local_vars_mutex.synchronize do
        thread.instance_variable_set(:@_inherited_local_vars, nil)
      end
    end
  end

  def self.inherited_local_vars_delete(key)
    inherited_local_vars_mutex.synchronize do
      raise "Key didn't exist: #{key}" unless _inherited_local_vars.key?(key)

      _inherited_local_vars.delete(key)
    end
  rescue ThreadError # This can happen when process is closing down
    _inherited_local_vars.delete(key)
  end

  def self.inherited_local_vars_fetch(key)
    inherited_local_vars_mutex.synchronize do
      return _inherited_local_vars.fetch(key)
    end
  end

  def self.inherited_local_vars_get(key)
    inherited_local_vars_mutex.synchronize do
      return _inherited_local_vars[key]
    end
  end

  def self.inherited_local_vars_set(values)
    inherited_local_vars_mutex.synchronize do
      current_vars = _inherited_local_vars
      new_vars = PeakFlowUtils::DeepMerger.execute!(hashes: [current_vars, values])
      Thread.current.instance_variable_set(:@_inherited_local_vars, new_vars)
    end
  end
end

class PeakFlowUtils::InheritedLocalVar
  attr_reader :identifier

  def self.identifier_for_object_id(object_id)
    "inherited_local_var_#{object_id}"
  end

  def self.finalize(inherited_local_var_object_id)
    identifier = PeakFlowUtils::InheritedLocalVar.identifier_for_object_id(inherited_local_var_object_id)
    Thread.inherited_local_vars_delete(identifier)
  rescue Exception => e # rubocop:disable Lint/RescueException
    puts e.inspect # rubocop:disable Rails/Output
    puts e.backtrace # rubocop:disable Rails/Output

    raise e
  end

  def initialize(new_value = nil)
    ObjectSpace.define_finalizer(self, PeakFlowUtils::InheritedLocalVar.method(:finalize))
    @identifier = PeakFlowUtils::InheritedLocalVar.identifier_for_object_id(__id__)
    Thread.inherited_local_vars_set(identifier => new_value)
  end

  def value
    Thread.inherited_local_vars_fetch(identifier)
  end

  def value=(new_value)
    Thread.inherited_local_vars_set(identifier => new_value)
  end
end
