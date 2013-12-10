class ArtistsController < ApplicationController

  # GET /artistas(/letra/:letter)
  def index
    @artists = Artist.list(params[:letter])
  end

  # GET /artistas/:id
  def show
    @artist = Artist.find_by_slug!(params[:id])
  end

end
