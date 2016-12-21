class AddStatusToIdentities < ActiveRecord::Migration
  def change
    add_column :identities, :status, :string, default: 'inactive'
  end
end
