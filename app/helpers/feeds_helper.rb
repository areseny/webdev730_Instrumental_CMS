module FeedsHelper

  def event_feed_description(event)
    "#{event.class.model_name.human} com #{event.artist.name}"
  end

end
