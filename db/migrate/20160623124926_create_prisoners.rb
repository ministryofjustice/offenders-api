class CreatePrisoners < ActiveRecord::Migration
  def change
    create_table :prisoners, id: :uuid do |t|
      t.string :noms_id, index: true
      t.string :title
      t.string :given_name, index: true
      t.string :middle_names
      t.string :surname, index: true
      t.string :suffix
      t.date   :date_of_birth
      t.string :gender
      t.string :nationality_code
      t.string :establishment_code
      t.string :pnc_number, index: true
      t.string :cro_number, index: true

      t.timestamps
    end
  end
end
