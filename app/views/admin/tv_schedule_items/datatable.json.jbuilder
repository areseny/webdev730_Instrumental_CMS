json.cache! @tv_schedule_items.maximum(:updated_at) do
  json.aaData do
    json.array! @tv_schedule_items do |item|
      date = l(item.starts_at, format: :list)
      json.array! [date, item.description, item.starts_at.to_i]
    end
  end
end
