class Admin::ArtistsController < AdminController

  def index
    @artists = Artist.page(params[:page]).order(:first_letter, :sort_name)
  end

  def edit
    @artist = Artist.find_by_slug!(params[:id])
  end

end
