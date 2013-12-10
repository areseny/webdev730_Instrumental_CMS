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

end
