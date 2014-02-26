class Admin::TvShowsController < AdminController

  def index
  end

  def datatable
    @tv_shows = TvShow.all
  end

  def typeahead
    @tv_shows = TvShow.all
  end

  def new
    @tv_show = TvShow.new(date: Date.current)
  end

  def create
    @tv_show = TvShow.new(tv_show_params)
    if @tv_show.save
      invalidate_cache
      flash[:success] = "admin.tv_shows.create"
      redirect_to admin_tv_shows_path
    else
      render :new
    end
  end

  def edit
    @tv_show = TvShow.find_by_slug!(params[:id])
  end

  def update
    @tv_show = TvShow.find_by_slug!(params[:id])
    if @tv_show.update_attributes(tv_show_params)
      invalidate_cache
      flash[:success] = "admin.tv_shows.update"
      redirect_to admin_tv_shows_path
    else
      render :edit
    end
  end

  def destroy
    @tv_show = TvShow.find_by_slug!(params[:id])
    @tv_show.destroy!
    invalidate_cache
    flash[:success] = "admin.tv_shows.destroy"
    redirect_to admin_tv_shows_path
  end

  private

  def tv_show_params
    params.require(:tv_show)
          .permit(:date, :artist_id, :description, :factsheet)
  end

  def invalidate_cache
    expire_fragment("tv-shows-datatable")
  end

end
