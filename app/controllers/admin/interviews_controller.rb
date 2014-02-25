class Admin::InterviewsController < AdminController

  def index
  end

  def datatable
    @interviews = Interview.all
  end

  def typeahead
    @interviews = Interview.all
  end

  def new
    @interview = Interview.new(date: Date.current)
  end

  def create
    @interview = Interview.new(interview_params)
    if @interview.save
      invalidate_cache
      flash[:success] = "admin.interviews.create"
      redirect_to admin_interviews_path
    else
      render :new
    end
  end

  def edit
    @interview = Interview.find_by_slug!(params[:id])
  end

  def update
    @interview = Interview.find_by_slug!(params[:id])
    if @interview.update_attributes(interview_params)
      invalidate_cache
      flash[:success] = "admin.interviews.update"
      redirect_to admin_interviews_path
    else
      render :edit
    end
  end

  def destroy
    @interview = Interview.find_by_slug!(params[:id])
    @interview.destroy!
    invalidate_cache
    flash[:success] = "admin.interviews.destroy"
    redirect_to admin_interviews_path
  end

  private

  def interview_params
    params.require(:interview)
          .permit(:date, :artist_id, :description, :timecodes_text)
  end

  def invalidate_cache
    expire_fragment("interviews-datatable")
  end

end
