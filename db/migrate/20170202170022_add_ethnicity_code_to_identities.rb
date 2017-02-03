class AddEthnicityCodeToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :ethnicity_code, :string
  end
end
