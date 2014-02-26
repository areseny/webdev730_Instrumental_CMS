class Admin::SoundChecksController < AdminController

  def index
  end

  def datatable
    @sound_checks = SoundCheck.all
  end

  def typeahead
    @sound_checks = SoundCheck.all
  end

  def new
    @sound_check = SoundCheck.new(date: Date.current)
  end

  def create
    @sound_check = SoundCheck.new(sound_check_params)
    if @sound_check.save
      invalidate_cache
      flash[:success] = "admin.sound_checks.create"
      redirect_to admin_sound_checks_path
    else
      render :new
    end
  end

  def edit
    @sound_check = SoundCheck.find_by_slug!(params[:id])
  end

  def update
    @sound_check = SoundCheck.find_by_slug!(params[:id])
    if @sound_check.update_attributes(sound_check_params)
      invalidate_cache
      flash[:success] = "admin.sound_checks.update"
      redirect_to admin_sound_checks_path
    else
      render :edit
    end
  end

  def destroy
    @sound_check = SoundCheck.find_by_slug!(params[:id])
    @sound_check.destroy!
    invalidate_cache
    flash[:success] = "admin.sound_checks.destroy"
    redirect_to admin_sound_checks_path
  end

  private

  def sound_check_params
    params.require(:sound_check)
          .permit(:date, :artist_id, :description, :factsheet)
  end

  def invalidate_cache
    expire_fragment("sound-checks-datatable")
  end

end
