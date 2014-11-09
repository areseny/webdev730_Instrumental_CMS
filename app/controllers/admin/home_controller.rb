class Admin::HomeController < AdminController
  def dashboard
  end

  def sync_videos
    flash[:success] = 'Vídeos sincronizados.'
    redirect_to admin_root_path
  end

  def clear_cache
    Dalli::Client.new.flush

    flash[:success] = 'Cache limpo.'
    redirect_to admin_root_path
  end
end
