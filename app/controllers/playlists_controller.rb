class PlaylistsController < ApplicationController

  # GET /playlists
  def index
    @playlist = Playlist.load_from_cookie(request.cookies['instrumental-playlist'])
  end

  # GET /playlists/busca?q=foo
  def search
    query = params[:q].try(:strip)
    if query && query.length > 0
      @songs = Song.search(query).order("artists.name, songs.title").limit(50)
    else
      @songs = []
    end
  end

end
