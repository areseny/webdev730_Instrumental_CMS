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

  # GET ui/show.aspx?id=:id
  def legacy_show
    @show = Show.find_by_legacy_id!(params[:id])
    redirect_to artist_event_url(@show.artist, @show), :status => :moved_permanently
  end

  # GET ui/interview.aspx?id=:id
  def legacy_interview
    @interview = Interview.find_by_legacy_id!(params[:id])
    redirect_to artist_event_url(@interview.artist, @interview), :status => :moved_permanently
  end

  # GET ui/interview.aspx?id=:id
  def legacy_video_chat
    @video_chat = VideoChat.find_by_legacy_id!(params[:id])
    redirect_to artist_event_url(@video_chat.artist, @video_chat), :status => :moved_permanently
  end

end
