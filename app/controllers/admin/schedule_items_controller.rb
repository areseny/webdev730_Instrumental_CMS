class Admin::ScheduleItemsController < AdminController

  def index
  end

  def datatable
    @schedule_items = ScheduleItem.all
  end

  def new
    @schedule_item = ScheduleItem.new(date: Date.current)
  end

  def create
    @schedule_item = ScheduleItem.new(schedule_item_params)
    if @schedule_item.save
      invalidate_cache
      flash[:success] = "admin.schedule_items.create"
      redirect_to admin_schedule_items_path
    else
      render :new
    end
  end

  def edit
    @schedule_item = ScheduleItem.find(params[:id])
  end

  def update
    @schedule_item = ScheduleItem.find(params[:id])
    if @schedule_item.update_attributes(schedule_item_params)
      invalidate_cache
      flash[:success] = "admin.schedule_items.update"
      redirect_to admin_schedule_items_path
    else
      render :edit
    end
  end

  def destroy
    @schedule_item = ScheduleItem.find(params[:id])
    @schedule_item.destroy!
    invalidate_cache
    flash[:success] = "admin.schedule_items.destroy"
    redirect_to admin_schedule_items_path
  end

  private

  def schedule_item_params
    params.require(:schedule_item)
          .permit(:date, :artist_id, :description)
  end

  def invalidate_cache
    expire_fragment("schedule-items-datatable")
    expire_fragment("schedule-items-homepage-#{Date.current.to_s}")
  end

end
