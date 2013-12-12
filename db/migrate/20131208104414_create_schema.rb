class CreateSchema < ActiveRecord::Migration
  def change

    create_table :artists do |t|
      t.string :slug,         null: false
      t.string :name,         null: false
      t.text :description,    null: false
      t.string :sort_name,    null: false
      t.string :first_letter, null: false, limit: 1
      t.integer :legacy_ids,  null: false, array: true, default: []
      t.string :facebook_page
      t.string :twitter_widget_id
      t.timestamps
    end
    add_index :artists, :slug, unique: true
    add_index :artists, :name, unique: true
    add_index :artists, :sort_name

    create_table :instruments do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :instruments, :name, unique: true

    create_table :artists_instruments, id: false do |t|
      t.belongs_to :artist,     null: false
      t.belongs_to :instrument, null: false
    end
    add_index :artists_instruments, [:artist_id, :instrument_id],
              name: "unique_artists_instruments", unique: true

    create_table :genres do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :genres, :name, unique: true

    create_table :events do |t|
      t.belongs_to :artist,       null: false
      t.date       :date,         null: false
      t.string     :type,         null: false
      t.string     :slug,         null: false
      t.text       :description,  null: false
      t.boolean    :visible,      null: false, default: false
      t.text       :factsheet
      t.integer    :legacy_id
      t.timestamps
    end
    add_index :events, :artist_id
    add_index :events, [:date, :type], unique: true
    add_index :events, :slug, unique: true

    create_table :songs do |t|
      t.belongs_to :playlistable,  null: false, polymorphic: true
      t.string :title,             null: false
      t.string :composer,          null: false
      t.integer :position,         null: false, default: 0
      t.timestamps
    end
    add_index :songs, [:playlistable_type, :playlistable_id, :position],
              name: "unique_songs", unique: true

    create_table :genres_songs, id: false do |t|
      t.belongs_to :genre, null: false
      t.belongs_to :song, null: false
    end
    add_index :genres_songs, [:genre_id, :song_id], unique: true

    create_table :band_members do |t|
      t.belongs_to :song,         null: false
      t.string     :artist_name,  null: false
      t.timestamps
    end
    add_index :band_members, :song_id

    create_table :band_members_instruments, id: false do |t|
      t.belongs_to :band_member, null: false
      t.belongs_to :instrument,  null: false
    end
    add_index :band_members_instruments, [:band_member_id, :instrument_id],
              name: "unique_band_members_instruments", unique: true

    create_table :videos do |t|
      t.belongs_to :viewable,     null: false, polymorphic: true
      t.string     :auth_user_id, null: false
      t.string     :youtube_id,   null: false
      t.string     :title,        null: false
      t.text       :description,  null: false
      t.string     :tags,         null: false, array: true, default: []
      t.integer    :views,        null: false, default: 0
      t.integer    :likes,        null: false, default: 0
      t.integer    :dislikes,     null: false, default: 0
      t.integer    :comments,     null: false, default: 0
      t.string     :small_thumbnail
      t.string     :large_thumbnail
      t.timestamps
    end
    add_index :videos, [:viewable_type, :viewable_id]
    add_index :videos, :youtube_id, unique: true

    create_table :timecodes do |t|
      t.belongs_to :video,       null: false
      t.integer    :seconds,     null: false
      t.text       :description, null: false
      t.timestamps
    end
    add_index :timecodes, [:video_id, :seconds]

  end
end
