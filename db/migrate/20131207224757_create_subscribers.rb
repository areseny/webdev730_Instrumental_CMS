class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :name,     null: false
      t.string :email,    null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps
    end
    add_index :subscribers, :email, unique: true
  end
end
