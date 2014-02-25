class Admin::ShowsController < AdminController

  def index
  end

  def datatable
    @shows = Show.all
  end

  def typeahead
    @shows = Show.all
  end

  def new
    @show = Show.new(date: Date.current)
  end

  def create
    @show = Show.new(show_params)
    if @show.save
      invalidate_cache
      flash[:success] = "admin.shows.create"
      redirect_to admin_shows_path
    else
      render :new
    end
  end

  def edit
    @show = Show.find_by_slug!(params[:id])
  end

  def update
    @show = Show.find_by_slug!(params[:id])
    if @show.update_attributes(show_params)
      invalidate_cache
      flash[:success] = "admin.shows.update"
      redirect_to admin_shows_path
    else
      render :edit
    end
  end

  def destroy
    @show = Show.find_by_slug!(params[:id])
    @show.destroy!
    invalidate_cache
    flash[:success] = "admin.shows.destroy"
    redirect_to admin_shows_path
  end

  private

  def show_params
    params.require(:show)
          .permit(:date, :artist_id, :description)
  end

  def invalidate_cache
    expire_fragment("shows-datatable")
  end

end
