class AddErrorLogToImports < ActiveRecord::Migration[5.0]
  def change
    add_column :imports, :error_log, :text
  end
end
