class RenameNomsOffenderIdToNomisOffenderId < ActiveRecord::Migration[5.0]
  def change
    rename_column :identities, :noms_offender_id, :nomis_offender_id
  end
end
