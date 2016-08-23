class CreateTemporaryTables < ActiveRecord::Migration
  def change
    create_table :temporary_prisoners, id: :uuid do |t|
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

    create_table :temporary_aliases do |t|
      t.uuid :prisoner_id, index: true, foreign_key: true

      t.string :title
      t.string :given_name, index: true
      t.string :middle_names
      t.string :surname, index: true
      t.string :suffix
      t.string :gender
      t.date :date_of_birth
    end
  end
end
