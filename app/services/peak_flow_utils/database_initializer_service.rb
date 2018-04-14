class PeakFlowUtils::DatabaseInitializerService < PeakFlowUtils::ApplicationService
  def execute!
    path = File.dirname("#{File.dirname(__FILE__)}/../../migrations")

    puts "Path: #{path}"

    Dir["#{path}/[0-9]*_*.rb"].sort.map do |filename|
      match = filenamt.match(/\A(\d+)_(.+)\.rb\Z/)
      next unless match

      require filename
      migration = match[2].camelize.constantize
      migration.up
    end
  end
end
