class CreateContactMessages < ActiveRecord::Migration
  def change
    create_table :contact_messages do |t|
      t.string :email,    null: false, index: true
      t.string :name,     null: false, index: true
      t.text   :message,  null: false
      t.string :ip_address

      t.timestamps
    end
  end
end
