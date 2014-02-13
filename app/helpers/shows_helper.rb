module ShowsHelper

  def show_selector_display(show)
    if show && show.artist
      "#{show.artist.name} (#{l(show.date, format: :brief)})"
    end
  end

end
