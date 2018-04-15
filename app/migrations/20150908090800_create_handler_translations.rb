class CreateHandlerTranslations < PeakFlowUtils::ApplicationMigration
  def change
    create_table :peak_flow_utils_handler_translations do |t|
      t.belongs_to :handler, null: false
      t.belongs_to :translation_key, index: false, null: false
      t.belongs_to :group, null: false
      t.string :key_show
      t.string :file_path
      t.integer :line_no
      t.string :full_path, index: true
      t.string :dir
      t.string :default
      t.timestamps
    end

    add_index :peak_flow_utils_handler_translations, :handler_id, name: "index_handler_translations_handler_id"

    add_foreign_key :peak_flow_utils_handler_translations, :peak_flow_utils_handlers, column: "handler_id"
    add_foreign_key :peak_flow_utils_handler_translations, :peak_flow_utils_translation_keys, column: "translation_key_id"
    add_foreign_key :peak_flow_utils_handler_translations, :peak_flow_utils_groups, column: "group_id"
  end
end
