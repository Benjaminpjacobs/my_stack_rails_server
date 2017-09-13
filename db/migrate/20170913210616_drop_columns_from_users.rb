class DropColumnsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :provider, :string
    remove_column :users, :token, :string
    remove_column :users, :uid, :string
    remove_column :users, :username, :string
  end
end
