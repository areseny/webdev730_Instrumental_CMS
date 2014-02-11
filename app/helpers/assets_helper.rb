module AssetsHelper

  def fontawesome_asset_tags
    if Rails.env.production?
      # Use Twitter's CDN server on production
      raw %(<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">)
    else
      # Use local file from /vendor/assets in development
      raw %(<link href="/assets/font-awesome-4.0.3.css?body=1" media="screen" rel="stylesheet" />)
    end
  end

end
