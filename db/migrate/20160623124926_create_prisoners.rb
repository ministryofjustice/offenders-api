class CreatePrisoners < ActiveRecord::Migration
  def change
    create_table :prisoners, id: :uuid do |t|
      t.string  :noms_id, index: true
      t.string  :given_name
      t.string  :middle_names
      t.string  :surname
      t.string  :title
      t.string  :suffix
      t.date    :date_of_birth
      t.string  :gender
      t.string  :pnc_number, index: true
      t.string  :nationality_code
      t.string  :cro_number

      t.timestamps
    end
  end
end
