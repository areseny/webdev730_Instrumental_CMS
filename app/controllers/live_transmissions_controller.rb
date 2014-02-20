class LiveTransmissionsController < ApplicationController

  def show
    @transmission = LiveTransmission.find(params[:id])
    @next_transmissions = LiveTransmission.next
  end

end
