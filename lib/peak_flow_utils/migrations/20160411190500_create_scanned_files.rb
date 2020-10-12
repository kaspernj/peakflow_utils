class CreateScannedFiles < PeakFlowUtils::ApplicationMigration
  def change
    create_table :peak_flow_utils_scanned_files do |t|
      t.string :file_path, index: true, null: false
      t.integer :file_size, null: false
      t.datetime :last_changed_at, null: false
      t.timestamps
    end
  end
end
