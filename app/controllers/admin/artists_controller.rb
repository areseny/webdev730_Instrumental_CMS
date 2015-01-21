class Admin::ArtistsController < AdminController
  def index
  end

  def datatable
    @artists = Artist.order(:first_letter, :sort_name).to_a
  end

  def typeahead
    @artists = Artist.order(:first_letter, :sort_name)
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      invalidate_cache
      flash[:success] = "admin.artists.create"
      redirect_to admin_artists_path
    else
      render :new
    end
  end

  def edit
    @artist = Artist.find_by_slug!(params[:id])
  end

  def update
    @artist = Artist.find_by_slug!(params[:id])

    if @artist.update_attributes(artist_params)
      flash[:success] = "admin.artists.update"
      redirect_to admin_artists_path
    else
      render :edit
    end
  end

  def destroy
    @artist = Artist.find_by_slug!(params[:id])
    @artist.destroy!

    flash[:success] = "admin.artists.destroy"
    redirect_to admin_artists_path
  end

  private

  def artist_params
    params.require(:artist)
          .permit(:name, :description, :instrument_names, :genre_names,
                  :facebook_page, :twitter_widget_id, :playlist_embed,
                  :banner, :thumbnail)
  end

  def invalidate_cache
    expire_fragment("artists-list")
  end
end
