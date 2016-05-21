class Admin::LiveTransmissionsController < AdminController

  def index
  end

  def datatable
    @live_transmissions = LiveTransmission.all
  end

  def new
    @live_transmission = LiveTransmission.new(date: Date.current)
  end

  def create
    @live_transmission = LiveTransmission.new(live_transmission_params)
    if @live_transmission.save
      invalidate_cache
      flash[:success] = "admin.live_transmissions.create"
      redirect_to admin_live_transmissions_path
    else
      render :new
    end
  end

  def edit
    @live_transmission = LiveTransmission.find(params[:id])
  end

  def update
    @live_transmission = LiveTransmission.find(params[:id])
    if @live_transmission.update_attributes(live_transmission_params)
      invalidate_cache
      flash[:success] = "admin.live_transmissions.update"
      redirect_to admin_live_transmissions_path
    else
      render :edit
    end
  end

  def destroy
    @live_transmission = LiveTransmission.find(params[:id])
    @live_transmission.destroy!
    invalidate_cache
    flash[:success] = "admin.live_transmissions.destroy"
    redirect_to admin_live_transmissions_path
  end

  private

  def live_transmission_params
    params.require(:live_transmission)
          .permit(:date, :artist_id, :description, :band_members, :live_video)
  end

  def invalidate_cache
    expire_fragment("live-transmissions-datatable")
    expire_fragment("live-transmissions-next-list-#{Date.current.to_s}")
  end

end
