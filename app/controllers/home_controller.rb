class HomeController < ApplicationController

  # GET /
  def index
    @features = Feature.enabled
  end

  # GET /projeto
  def about_us
  end

  # GET /privacidade
  def privacy
  end

  def live
    if @transmission = LiveTransmission.current
      redirect_to @transmission
    else
      redirect_to root_path
    end
  end

  def live_status
    render :json => LiveTransmission.live_status
  end

end
