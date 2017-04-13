class SsoUsers < ActiveRecord::Migration[5.0]
  def change
    remove_columns(
      :users,
      :encrypted_password,
      :reset_password_token,
      :reset_password_sent_at,
      :remember_created_at,
      :sign_in_count,
      :current_sign_in_at,
      :last_sign_in_at,
      :current_sign_in_ip,
      :last_sign_in_ip,
      :failed_attempts,
      :locked_at
    )
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end
end
