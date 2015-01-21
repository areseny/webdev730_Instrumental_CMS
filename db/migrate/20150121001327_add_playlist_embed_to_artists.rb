class AddPlaylistEmbedToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :playlist_embed, :text
  end
end
