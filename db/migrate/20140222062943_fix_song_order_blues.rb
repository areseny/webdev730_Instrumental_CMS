class FixSongOrderBlues < ActiveRecord::Migration
  def up
    remove_index "songs", :name => "unique_songs"
    Song.update_all("position = (position * -1) + 100")
  end
  def down
    add_index "songs", ["playlistable_type", "playlistable_id", "position"], name: "unique_songs", unique: true, using: :btree
  end
end
