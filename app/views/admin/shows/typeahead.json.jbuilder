json.cache! @shows do
  json.array! @shows do |show|
    json.id show.id
    json.name show_selector_display(show)
    json.artist_description show.artist.description
  end
end