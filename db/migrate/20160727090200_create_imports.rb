class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :offenders_file
      t.string :identities_file
      t.string :status, default: 'in_progress'

      t.timestamps
    end
  end
end
