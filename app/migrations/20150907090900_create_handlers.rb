class CreateHandlers < ActiveRecord::Migration[5.1]
  def change
    create_table :handlers do |t|
      t.string :identifier
      t.string :name
      t.timestamps
    end

    add_index :handlers, :identifier
  end
end
