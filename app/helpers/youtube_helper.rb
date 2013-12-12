module YoutubeHelper

  def youtube_meta_tags
    meta_tags({
      "youtube-origin" => request.base_url,
      "youtube-autoplay" => Rails.env.development? ? 0 : 1
    })
  end

end
