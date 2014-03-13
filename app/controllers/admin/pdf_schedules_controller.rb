class Admin::PdfSchedulesController < AdminController

  def index
  end

  def datatable
    @pdf_schedules = PdfSchedule.order('available_date desc')
  end

  def new
    @pdf_schedule = PdfSchedule.new(available_date: Date.current)
  end

  def create
    @pdf_schedule = PdfSchedule.new(pdf_schedule_params)
    if @pdf_schedule.save
      invalidate_cache
      flash[:success] = "admin.pdf_schedules.create"
      redirect_to admin_pdf_schedules_path
    else
      render :new
    end
  end

  def destroy
    @pdf_schedule = PdfSchedule.find(params[:id])
    @pdf_schedule.destroy
    invalidate_cache
    flash[:success] = "admin.pdf_schedules.destroy"
    redirect_to admin_pdf_schedules_path
  end

  private

  def invalidate_cache
    expire_fragment("pdf-schedules-datatable")
    expire_fragment("pdf_schedule-homepage")
    expire_fragment("schedule-items-homepage-#{Date.current.to_s}")
  end

  def pdf_schedule_params
    params.require(:pdf_schedule).permit(:available_date, :file)
  end

end
