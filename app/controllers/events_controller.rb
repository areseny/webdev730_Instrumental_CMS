class EventsController < ApplicationController

  # GET /artistas/:artist_id/:id
  def show
    @artist = Artist.find_by_slug!(params[:artist_id])
    @event = @artist.events.find_by_slug!(params[:id])
  end

end
