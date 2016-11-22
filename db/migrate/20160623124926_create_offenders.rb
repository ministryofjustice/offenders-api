class CreateOffenders < ActiveRecord::Migration
  def change
    create_table :offenders, id: :uuid do |t|
      t.uuid :current_identity_id, index: true
      t.string :noms_id, index: true
      t.string :nationality_code
      t.string :establishment_code

      t.timestamps
    end
  end
end
