class CreateHandlers < PeakFlowUtils::ApplicationMigration
  def change
    create_table :peak_flow_utils_handlers do |t|
      t.string :identifier, index: true, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
