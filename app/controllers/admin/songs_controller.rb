class Admin::SongsController < AdminController
  before_filter do
    if params[:show_id]
      @show = Show.find_by_slug!(params[:show_id])
    else
      @show = LegacyShow.find_by_slug!(params[:legacy_show_id])
    end
  end

  def index
    @songs = @show.songs.order(:position)
  end

  def reorder
    Song.transaction do
      @show.songs.update_all("position = position - 100")
      (params[:songs] || []).each do |song|
        Song.where(id: song[:id]).update_all(position: song[:position])
      end
    end
    flash[:success] = "admin.songs.reorder"
    redirect_to_index
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])
    if @song.update_attributes(song_params)
      invalidate_cache
      flash[:success] = "admin.songs.update"
      redirect_to_index
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy!
    invalidate_cache
    flash[:success] = "admin.songs.destroy"
    redirect_to_index
  end

  private

  def song_params
    params.require(:song)
          .permit(:title, :composer)
  end

  def invalidate_cache
  end

  def redirect_to_index
    if @show.is_a?(LegacyShow)
      redirect_to admin_legacy_show_songs_path(@show)
    else
      redirect_to admin_show_songs_path(@show)
    end
  end

end
