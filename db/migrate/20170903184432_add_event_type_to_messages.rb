class AddEventTypeToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :event_type, :string
  end
end
