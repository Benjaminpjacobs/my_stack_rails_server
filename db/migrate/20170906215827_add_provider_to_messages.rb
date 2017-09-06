class AddProviderToMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :service, foreign_key: true
  end
end
