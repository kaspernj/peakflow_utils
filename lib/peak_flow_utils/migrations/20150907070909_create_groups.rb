class CreateGroups < PeakFlowUtils::ApplicationMigration
  def change
    create_table :peak_flow_utils_groups do |t|
      t.references :handler, null: false
      t.string :identifier, index: true
      t.string :name
      t.timestamps
    end

    add_foreign_key :peak_flow_utils_groups, :peak_flow_utils_handlers, column: "handler_id"
  end
end
