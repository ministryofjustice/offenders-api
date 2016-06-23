class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.references :prisoner, index: true, foreign_key: true
      t.string :name
    end
    add_index :aliases, :name
  end
end
