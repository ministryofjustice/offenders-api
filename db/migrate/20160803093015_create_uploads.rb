class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.string :md5

      t.timestamps null: false
    end
    add_index :uploads, :md5
  end
end
