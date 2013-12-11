module TwitterHelper

  def twitter_timeline(artist)
    if artist.twitter_widget_id?
      options = {
        class: 'twitter-timeline',
        data: {
          widget_id: artist.twitter_widget_id,
          dnt: true
        }
      }
      link_to "", "http://twitter.com", options
    end
  end

end
