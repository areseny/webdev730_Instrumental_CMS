class CreateAuthProviders < ActiveRecord::Migration
  def up
    create_table :auth_providers do |t|
      t.string :key,    null: false
      t.string :name,   null: false
      t.string :token
      t.string :user_id
      t.string :user_name
      t.datetime :synced_at
      t.timestamps
    end
    add_index :auth_providers, :key, unique: true
    AuthProvider.create!(key: 'youtube', name: "YouTube")
    AuthProvider.create!(key: 'soundcloud', name: "SoundCloud")
  end
  def down
    drop_table :auth_providers
  end
end
