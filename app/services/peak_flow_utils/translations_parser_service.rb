class PeakFlowUtils::TranslationsParserService < PeakFlowUtils::ApplicationService
  attr_reader :db

  def execute
    PeakFlowUtils::DatabaseInitializerService.execute!

    cache_translations_in_dir(Rails.root.join("config", "locales"))
    cache_translations_in_handlers

    clean_up_not_found

    ServicePattern::Response.new(success: true)
  end

  def with_transactioner
    require "active-record-transactioner"

    ActiveRecordTransactioner.new do |transactioner|
      @transactioner = transactioner
      yield
    end
  end

  def self.database_path
    @database_path ||= Rails.root.join("db", "peak_flow_utils.sqlite3").to_s
  end

  def database_path
    @database_path ||= self.class.database_path
  end

  def update_handlers
    @handlers_found ||= {}

    PeakFlowUtils::HandlersFinderService.execute!.each do |handler|
      debug "Updating handler: #{handler.name}"
      handler_model = PeakFlowUtils::Handler.find_or_initialize_by(identifier: handler.id)
      handler_model.update!(name: handler.name)

      @handlers_found[handler_model.id] = true

      yield handler_model if block_given?
    end
  end

  def update_groups_for_handler(handler_model)
    @groups_found ||= {}
    handler = handler_model.at_handler

    handler.groups.each do |group|
      debug "Updating group: #{group.name}"
      group_model = PeakFlowUtils::Group.find_or_initialize_by(handler_id: handler_model.id, identifier: group.id)
      group_model.update!(name: group.name)

      @groups_found[group_model.id] = true

      group_model.at_group = group
      yield group_model if block_given?
    end
  end

  def update_translations_for_group(handler_model, group_model)
    group = group_model.at_group
    @translation_keys_found ||= {}
    @handler_translations_found ||= {}

    group.translations.each do |translation|
      debug "Updating translation: #{translation.key}"

      translation_key = PeakFlowUtils::TranslationKey.find_or_create_by!(key: translation.key)

      raise "KEY ERROR: #{translation_key.inspect}" unless translation_key.id.to_i.positive?

      @translation_keys_found[translation_key.id] = true

      handler_translation = PeakFlowUtils::HandlerText.find_or_initialize_by(
        translation_key_id: translation_key.id,
        handler_id: handler_model.id,
        group_id: group_model.id
      )
      handler_translation.assign_attributes(
        default: translation.default,
        file_path: translation.file_path,
        line_no: translation.line_no,
        key_show: translation.key_show,
        full_path: translation.full_path,
        dir: translation.dir
      )

      if @transactioner && handler_translation.persisted?
        @transactioner.save!(handler_translation)
      else
        handler_translation.save!
      end

      @handler_translations_found[handler_translation.id] = true
    end
  end

private

  def debug(message)
    puts message.to_s if @debug # rubocop:disable Rails/Output
  end

  def execute_migrations
    require "baza_migrations"

    executor = BazaMigrations::MigrationsExecutor.new(db: @db)
    executor.add_dir "#{File.dirname(__FILE__)}/../../db/baza_translations_migrations"
    executor.execute_migrations
  end

  def cache_translations_in_handlers
    with_transactioner do
      update_handlers do |handler_model|
        update_groups_for_handler(handler_model) do |group_model|
          update_translations_for_group(handler_model, group_model)
        end
      end
    end
  end

  def cache_translations_in_dir(dir_path)
    debug "Looking for translations in #{dir_path}"
    @translation_values_found ||= {}

    Dir.foreach(dir_path) do |file|
      next if file == "." || file == ".."

      full_path = "#{dir_path}/#{file}"

      if File.directory?(full_path)
        cache_translations_in_dir(full_path)
      elsif File.extname(full_path) == ".yml"
        cache_translations_in_file(full_path)
      end
    end
  end

  def cache_translations_in_file(file_path)
    @translation_keys_found ||= {}

    debug "Cache translations in #{file_path}"

    i18n_hash = YAML.load_file(file_path)
    debug "Hash: #{i18n_hash}"

    i18n_hash.each do |locale, translations|
      cache_translations_in_hash(file_path, locale, translations)
    end

    debug "Done caching translations in #{file_path}"
  end

  def cache_translations_in_hash(file_path, locale, i18n_hash, keys = [])
    i18n_hash.each do |key, value|
      current_key = keys.clone
      current_key << key

      if value.is_a?(Hash)
        debug "Found new hash: #{current_key.join(".")}"
        cache_translations_in_hash(file_path, locale, value, current_key)
      else
        debug "Found new key: #{current_key.join(".")} translated to #{value}"

        key = current_key.join(".")

        translation_key = PeakFlowUtils::TranslationKey.find_or_create_by!(key: key)
        @translation_keys_found[translation_key.id] = true
        raise "KEY ERROR: #{translation_key.inspect}" unless translation_key.id.to_i.positive?

        translation_value = PeakFlowUtils::TranslationValue.find_or_initialize_by(
          translation_key_id: translation_key.id,
          locale: locale,
          file_path: file_path
        )
        translation_value.assign_attributes(value: value)
        translation_value.save!

        @translation_values_found[translation_value.id] = true
      end
    end
  end

  def clean_up_not_found
    debug "Cleaning up not found"

    PeakFlowUtils::ApplicationRecord.transaction do
      PeakFlowUtils::Handler
        .where.not(id: @handlers_found.keys)
        .destroy_all

      PeakFlowUtils::HandlerText
        .where.not(id: @handler_translations_found.keys)
        .destroy_all

      PeakFlowUtils::Group
        .where.not(id: @groups_found.keys)
        .destroy_all

      PeakFlowUtils::TranslationKey
        .where.not(id: @translation_keys_found.keys)
        .destroy_all

      PeakFlowUtils::TranslationValue
        .where.not(id: @translation_values_found.keys)
        .destroy_all
    end
  end
end
