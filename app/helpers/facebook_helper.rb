module FacebookHelper

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
