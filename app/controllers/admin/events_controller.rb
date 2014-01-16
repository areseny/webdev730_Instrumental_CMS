class Admin::EventsController < AdminController

  def edit
    @event = Event.find_by_slug!(params[:id])
  end

  def update
    @event = Event.find_by_slug!(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = "admin.events.update"
      redirect_to admin_artist_path(@event.artist)
    else
      render :edit
    end
  end

  private

  def event_params
    params.require(:event)
          .permit(:description)
  end

end
