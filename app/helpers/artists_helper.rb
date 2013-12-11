module ArtistsHelper

  # Replaces '#' by '_' when generating the url
  def letter_artists_path(letter)
    super(letter == '#' ? '_' : letter.downcase)
  end

  def artist_banner(artist)
    image_tag(artist.banner.url,
              title: artist.name, alt: artist.name, class: 'round',
              width: artist.banner_width, height: artist.banner_height)
  end

  def artist_instruments(artist)
    artist_details(artist.instruments, "Instrumentos")
  end

  def artist_genres(artist)
    artist_details(artist.genres, "Gêneros")
  end

  private

  def artist_details(items, title)
    if items.any?
      sentence = items.map { |item| item.name.titleize }.to_sentence
      list = definition_list(title => sentence)
      content_tag :div, list, class: 'block artist-details'
    end
  end

end
