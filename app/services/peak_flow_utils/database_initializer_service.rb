class PeakFlowUtils::DatabaseInitializerService < PeakFlowUtils::ApplicationService
  def execute!
    path = File.realpath("#{File.dirname(__FILE__)}/../../migrations")

    puts "Path: #{path}"

    Dir["#{path}/[0-9]*_*.rb"].sort.map do |filename|
      match = filename.match(/migrations\/(\d+)_(.+)\.rb\Z/)
      next unless match

      require filename
      migration = match[2].camelize.constantize
      puts "Running migration: #{migration}"
      migration.migrate(:up)
    end
  end
end
