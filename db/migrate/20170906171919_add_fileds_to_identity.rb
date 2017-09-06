class AddFiledsToIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :refresh_token, :string
    add_column :identities, :expires_at, :integer
  end
end
