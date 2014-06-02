class Playlist

  def initialize(songs)
    @songs = songs
  end

  def songs
    @songs ||= []
  end

  def self.load_from_cookie(cookie)
    song_ids = (cookie || "").split("|")
    songs = song_ids.map do |id|
      Song.find_by_id(id)
    end
    Playlist.new(songs.compact)
  end

end
