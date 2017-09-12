class AddHookSettoIdentity < ActiveRecord::Migration[5.1]
  def change
    add_column :identities, :hooks_set, :boolean
  end
end
