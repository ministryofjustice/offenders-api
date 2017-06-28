class AddTimestampsToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :identities
  end
end
