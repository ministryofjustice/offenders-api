class CreatePrisoners < ActiveRecord::Migration
  def change
    create_table :prisoners do |t|
      t.string :noms_id, index: true
      t.string :offender_id, index: true
      t.string :given_name
      t.string :middle_names
      t.string :surname
      t.string :title
      t.string :suffix
      t.date :date_of_birth
      t.string :gender
      t.string :pnc_number, index: true
      t.string :nationality
      t.string :ethnicity
      t.string :languages
      t.boolean :requires_interpreter
      t.string :sexual_orientation

      t.timestamps
    end
  end
end
