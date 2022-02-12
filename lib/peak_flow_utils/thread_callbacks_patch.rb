class Thread
  alias_method :_initialize, :initialize # rubocop:disable Style/Alias

  def self.on_initialize(&callback)
    @@on_initialize_count = 0 if @on_initialize_count.nil? # rubocop:disable Style/ClassVars
    count_to_use = @@on_initialize_count
    @@on_initialize_count += 1 # rubocop:disable Style/ClassVars

    @@on_initialize_callbacks ||= {} # rubocop:disable Style/ClassVars
    @@on_initialize_callbacks[count_to_use] = callback

    count_to_use
  end

  def initialize(*args, &block)
    @@on_initialize_callbacks ||= {} # rubocop:disable Style/ClassVars
    @@on_initialize_callbacks.each_value do |callback|
      callback.call(parent: Thread.current, thread: self)
    end

    _initialize(*args, &block)
  end
end
