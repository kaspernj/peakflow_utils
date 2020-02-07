class CreateTranslationKeys < PeakFlowUtils::ApplicationMigration
  def change
    create_table :peak_flow_utils_translation_keys do |t|
      t.string :key, index: true, null: false
      t.timestamps
    end
  end
end
