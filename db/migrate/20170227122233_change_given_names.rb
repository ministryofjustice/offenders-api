class ChangeGivenNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :identities, :given_name, :given_name_1
    rename_column :identities, :middle_names, :given_name_2
    add_column :identities, :given_name_3, :string
  end
end
