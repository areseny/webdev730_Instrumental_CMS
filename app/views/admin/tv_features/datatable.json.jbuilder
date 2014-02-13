json.cache! @tv_features.maximum(:updated_at) do
  json.aaData do
    json.array! @tv_features do |feature|
      date = link_to l(feature.debuts_at, format: :list), edit_admin_tv_feature_path(feature)
      json.array! [date, feature.artist.name, feature.description, feature.debuts_at.to_i]
    end
  end
end
