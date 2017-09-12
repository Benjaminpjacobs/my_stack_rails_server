class AddHookAttributesToIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :hook_expires, :boolean
    add_column :identities, :hook_expires_at, :integer
  end
end
