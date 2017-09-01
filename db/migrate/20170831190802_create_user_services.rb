class CreateUserServices < ActiveRecord::Migration[5.1]
  def change
    create_table :users_services do |t|
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
    end
  end
end
