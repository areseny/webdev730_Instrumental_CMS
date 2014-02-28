class Show < Event
  include Playlistable

  def search_content
    content = super
    songs.each do |song|
      content << " #{song.title} #{song.composer}"
    end
    content
  end

  def search_genres
    songs.all.map(&:genres).flatten.uniq
  end

  def search_instruments
    songs.all.map(&:instruments).flatten.uniq
  end

  def search_result_type
    "Show"
  end

  def self.next_shows
    d = Date.current
    next_shows = where("date >= ?", d).order("date").limit(3).to_a
    previous_shows = where("date < ?", d).order("date desc").limit(4 - next_shows.length).to_a
    previous_shows.reverse + next_shows
  end

end
