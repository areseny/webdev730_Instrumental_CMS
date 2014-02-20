class Admin::LiveTransmissionSettingsController < AdminController

  def edit
    @settings = LiveTransmissionSettings.current
  end

  def update
    @settings = LiveTransmissionSettings.current
    if @settings.update_attributes(settings_params)
      flash[:success] = "admin.live_transmission_settings.update"
      redirect_to admin_live_transmissions_path
    else
      render :edit
    end
  end

  private

  def settings_params
    params.require(:live_transmission_settings)
          .permit(:starts_at, :ends_at)
  end

end
