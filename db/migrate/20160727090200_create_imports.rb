class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :file
      t.string :md5, index: true
      t.boolean :successful, default: false

      t.timestamps
    end
  end
end