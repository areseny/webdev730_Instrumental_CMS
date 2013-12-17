class Show < Event
  include Playlistable

  def self.next_shows
    d = Date.current
    previous_show = where("date < ?", d).order("date desc").first
    next_shows = where("date >= ?", d).order("date").limit(3).to_a
    next_shows.unshift(previous_show)
  end
end
