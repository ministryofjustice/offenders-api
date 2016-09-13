class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :prisoners_file
      t.string :aliases_file
      t.string :status, default: 'in_progress'

      t.timestamps
    end
  end
end
