class AddTokenToIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :token, :string
  end
end
