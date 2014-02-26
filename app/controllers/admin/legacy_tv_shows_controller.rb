class Admin::LegacyTvShowsController < AdminController


  def index
  end

  def datatable
    @legacy_tv_shows = LegacyTvShow.all
  end

  def typeahead
    @legacy_tv_shows = LegacyTvShow.all
  end

  def new
    @legacy_tv_show = LegacyTvShow.new(date: Date.current)
  end

  def create
    @legacy_tv_show = LegacyTvShow.new(legacy_tv_show_params)
    if @legacy_tv_show.save
      invalidate_cache
      flash[:success] = "admin.legacy_tv_shows.create"
      redirect_to admin_legacy_tv_shows_path
    else
      render :new
    end
  end

  def edit
    @legacy_tv_show = LegacyTvShow.find_by_slug!(params[:id])
  end

  def update
    @legacy_tv_show = LegacyTvShow.find_by_slug!(params[:id])
    if @legacy_tv_show.update_attributes(legacy_tv_show_params)
      invalidate_cache
      flash[:success] = "admin.legacy_tv_shows.update"
      redirect_to admin_legacy_tv_shows_path
    else
      render :edit
    end
  end

  def destroy
    @legacy_tv_show = LegacyTvShow.find_by_slug!(params[:id])
    @legacy_tv_show.destroy!
    invalidate_cache
    flash[:success] = "admin.legacy_tv_shows.destroy"
    redirect_to admin_legacy_tv_shows_path
  end

  private

  def legacy_tv_show_params
    params.require(:legacy_tv_show)
          .permit(:date, :artist_id, :description, :factsheet)
  end

  def invalidate_cache
    expire_fragment("legacy-tv-shows-datatable")
  end

end
