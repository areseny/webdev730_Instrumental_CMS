json.cache! @tv_features.maximum(:updated_at) do
  json.aaData do
    json.array! @tv_features do |feature|
      date = link_to l(feature.debuts_at, format: :list), edit_admin_tv_feature_path(feature)
      description =
        image_tag(feature.artist.thumbnail, size: '72x72', class: 'artist-list-thumb') +
        feature.description
      json.array! [date, feature.artist.name, description, feature.debuts_at.to_i]
    end
  end
end
