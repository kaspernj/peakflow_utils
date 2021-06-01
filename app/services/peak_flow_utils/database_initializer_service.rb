class PeakFlowUtils::DatabaseInitializerService < PeakFlowUtils::ApplicationService
  def perform
    path = File.realpath("#{__dir__}/../../../lib/peak_flow_utils/migrations")
    create_schema_table unless schema_table_exists?

    Dir["#{path}/[0-9]*_*.rb"].sort.map do |filename|
      match = filename.match(/migrations\/(\d+)_(.+)\.rb\Z/)
      next unless match

      version = match[1]
      next if version_migrated?(version)

      require filename
      migration = match[2].camelize.constantize
      migration.migrate(:up)
      register_migration_migrated(version)
    end

    succeed!
  end

private

  def create_schema_table
    PeakFlowUtils::ApplicationRecord.connection.execute("CREATE TABLE schema_migrations (version VARCHAR)")
  end

  def register_migration_migrated(version)
    PeakFlowUtils::ApplicationRecord.connection.execute("INSERT INTO schema_migrations (version) VALUES ('#{version}')")
  end

  def schema_table_exists?
    PeakFlowUtils::ApplicationRecord.connection.execute("SELECT * FROM sqlite_master WHERE type = 'table' AND name = 'schema_migrations'").any?
  end

  def version_migrated?(version)
    PeakFlowUtils::ApplicationRecord.connection.execute("SELECT * FROM schema_migrations WHERE version = '#{version}'").any?
  end
end
