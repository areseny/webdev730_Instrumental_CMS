module FacebookHelper

  def facebook_meta_tags
    meta_tags({
      "facebook-app-id" => ENV['FACEBOOK_APP_ID'],
      "facebook-channel-url" => "//#{request.host}/channel.html"
    })
  end

  def facebook_like_box(artist)
    if artist.facebook_page?
      options = {
        href: artist.facebook_page,
        colorscheme: 'light',
        show_faces: true,
        show_border: false,
        header: false,
        width: 335,
        stream: true
      }
      content_tag(:div, nil, class: 'fb-like-box', data: options)
    end
  end

end
