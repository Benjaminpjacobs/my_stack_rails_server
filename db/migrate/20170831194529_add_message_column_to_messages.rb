class AddMessageColumnToMessages < ActiveRecord::Migration[5.1]
  def change
      enable_extension 'hstore'
      add_column :messages, :message, :hstore
      add_index :messages, :message, using: :gist
  end
end
