class ChangeVersionsItemIdToUuid < ActiveRecord::Migration[5.0]
  def change
    add_column :versions, :uuid, :uuid, default: "uuid_generate_v4()", null: false

    # DESTROYS ALL EXISITING VERSION RECORDS
    PaperTrail::Version.delete_all

    change_table :versions do |t|
      t.remove :item_id
      t.rename :uuid, :item_id
    end
  end
end
