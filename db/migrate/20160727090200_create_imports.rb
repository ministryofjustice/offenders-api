class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :file

      t.timestamps
    end
  end
end
