class Admin::VideoChatsController < AdminController

  def index
  end

  def datatable
    @video_chats = VideoChat.all
  end

  def typeahead
    @video_chats = VideoChat.all
  end

  def new
    @video_chat = VideoChat.new(date: Date.current)
  end

  def create
    @video_chat = VideoChat.new(video_chat_params)
    if @video_chat.save
      invalidate_cache
      flash[:success] = "admin.video_chats.create"
      redirect_to admin_interviews_path
    else
      render :new
    end
  end

  def edit
    @video_chat = VideoChat.find_by_slug!(params[:id])
  end

  def update
    @video_chat = VideoChat.find_by_slug!(params[:id])
    if @video_chat.update_attributes(video_chat_params)
      invalidate_cache
      flash[:success] = "admin.video_chats.update"
      redirect_to admin_video_chats_path
    else
      render :edit
    end
  end

  def destroy
    @video_chat = VideoChat.find_by_slug!(params[:id])
    @video_chat.destroy!
    invalidate_cache
    flash[:success] = "admin.video_chats.destroy"
    redirect_to admin_video_chats_path
  end

  private

  def video_chat_params
    params.require(:video_chat)
          .permit(:date, :artist_id, :description, :timecodes_text)
  end

  def invalidate_cache
    expire_fragment("video-chats-datatable")
  end

end
