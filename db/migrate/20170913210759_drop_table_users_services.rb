class DropTableUsersServices < ActiveRecord::Migration[5.1]
  def change
    drop_table :users_services
  end
end
