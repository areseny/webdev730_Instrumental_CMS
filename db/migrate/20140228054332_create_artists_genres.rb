class CreateArtistsGenres < ActiveRecord::Migration
  def up
    create_table :artists_genres, id: false do |t|
      t.references :artist, null: false
      t.references :genre,  null: false
    end
    Genre.all.each do |genre|
      genre.artists << genre.songs.map(&:artist)
    end
  end
  def down
    drop_table :artists_genres
  end
end
