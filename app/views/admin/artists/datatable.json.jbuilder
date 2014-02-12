json.cache! "artists-list" do
  json.aaData do
    json.array! @artists do |artist|
      name = link_to(artist.name, [:admin, artist])
      dates = artist.dates.map{ |d| l(d, format: :brief) }.to_sentence
      instruments = artist.instruments.map(&:name).join(", ")
      description =
        image_tag(artist.thumbnail, size: '72x72', class: 'artist-list-thumb') +
        artist.description
      json.array! [name, dates, instruments, description, artist.sort_name]
    end
  end
end
