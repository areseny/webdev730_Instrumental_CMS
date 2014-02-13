json.cache! @artists.maximum(:updated_at) do
  json.array! @artists do |artist|
    json.extract! artist, :id, :name, :description
  end
end
