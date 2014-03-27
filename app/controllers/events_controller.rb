class EventsController < ApplicationController

  # GET /artistas/:artist_id/:id
  def show
    @artist = Artist.find_by_slug!(params[:artist_id])
    @event = @artist.events.find_by_slug!(params[:id])
  end

  # GET /artistas/:artist_id/:id/:song_id
  def song
    @artist = Artist.find_by_slug!(params[:artist_id])
    @event = @artist.shows.find_by_slug!(params[:event_id])
    @song = @event.songs.find(params[:song_id])
    render :show
  end

end
