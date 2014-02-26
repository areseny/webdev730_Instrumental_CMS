class Admin::LegacyShowsController < AdminController

  def index
  end

  def datatable
    @legacy_shows = LegacyShow.all
  end

  def typeahead
    @legacy_shows = LegacyShow.all
  end

  def new
    @legacy_show = LegacyShow.new(date: Date.current)
  end

  def create
    @legacy_show = LegacyShow.new(legacy_show_params)
    if @legacy_show.save
      invalidate_cache
      flash[:success] = "admin.shows.create"
      redirect_to admin_legacy_shows_path
    else
      render :new
    end
  end

  def edit
    @legacy_show = LegacyShow.find_by_slug!(params[:id])
  end

  def update
    @legacy_show = LegacyShow.find_by_slug!(params[:id])
    if @legacy_show.update_attributes(legacy_show_params)
      invalidate_cache
      flash[:success] = "admin.shows.update"
      redirect_to admin_legacy_shows_path
    else
      render :edit
    end
  end

  def destroy
    @legacy_show = LegacyShow.find_by_slug!(params[:id])
    @legacy_show.destroy!
    invalidate_cache
    flash[:success] = "admin.shows.destroy"
    redirect_to admin_legacy_shows_path
  end

  private

  def legacy_show_params
    params.require(:legacy_show)
          .permit(:date, :artist_id, :description)
  end

  def invalidate_cache
    expire_fragment("legacy-shows-datatable")
  end

end
