class Admin::TvScheduleItemsController < AdminController

  def index
  end

  def datatable
    @tv_schedule_items = TvScheduleItem.all
  end

  def import
  end

  def upload
    total = TvScheduleItem.import(params[:file])
    if total > 0
      invalidate_cache
      flash[:success] = "admin.tv_schedule_items.import"
    else
      flash[:warning] = "admin.tv_schedule_items.no_import"
    end
    redirect_to admin_tv_schedule_items_path
  end

  def clear
    TvScheduleItem.delete_all
    invalidate_cache
    flash[:success] = "admin.tv_schedule_items.clear"
    redirect_to admin_tv_schedule_items_path
  end

  private

  def invalidate_cache
    expire_fragment("tv-schedule-homepage-current-item-#{Date.current.to_s}")
    expire_fragment("tv-schedule-footer-feed-#{Date.current.to_s}")
    expire_fragment("tv-schedule-homepage")
  end

end
