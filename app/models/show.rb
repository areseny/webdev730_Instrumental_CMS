class Show < Event
  include Playlistable

  def self.next_shows
    d = Date.current
    next_shows = where("date >= ?", d).order("date").limit(3).to_a
    previous_shows = where("date < ?", d).order("date desc").limit(4 - next_shows.length).to_a
    previous_shows + next_shows
  end
end
