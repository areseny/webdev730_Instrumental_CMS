class Admin::ArtistsController < AdminController

  def index
    @artists = Artist.page(params[:page]).order(:first_letter, :sort_name)
  end

  def edit
    @artist = Artist.find_by_slug!(params[:id])
  end

  def update
    @artist = Artist.find_by_slug!(params[:id])
    if @artist.update_attributes(artist_params)
      flash[:success] = "Artista alterado com sucesso!"
      redirect_to admin_artists_path
    else
      render :edit
    end
  end

  private

  def artist_params
    params.require(:artist)
          .permit(:name, :description, :instrument_names)
  end


end
