class AddMergedToIdToOffenders < ActiveRecord::Migration[5.0]
  def change
    add_column :offenders, :merged_to_id, :uuid, default: nil
  end
end
