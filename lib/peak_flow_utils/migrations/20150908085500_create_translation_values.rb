class CreateTranslationValues < PeakFlowUtils::ApplicationMigration
  def change
    create_table :peak_flow_utils_translation_values do |t|
      t.references :translation_key, null: false
      t.string :file_path
      t.string :locale, index: true
      t.string :value
      t.timestamps
    end

    add_foreign_key :peak_flow_utils_translation_values, :peak_flow_utils_translation_keys, column: "translation_key_id"
  end
end
