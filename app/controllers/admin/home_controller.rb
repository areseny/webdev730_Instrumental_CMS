class Admin::HomeController < AdminController
  def dashboard
  end

  def sync_videos
    run_rake('videos:sync', 'Vídeos sincronizando')
  end

  def clear_cache
    run_rake('tmp:cache:clear', 'Cache limpo')
  end

  private

  def run_rake(name, success_message)
    rake = "RAILS_ENV=#{Rails.env} bundle exec rake #{name} --trace &"
    Kernel.system(rake)

    flash[:success] = success_message
  rescue => e
    Rails.logger.error e.message
    flash[:error] = 'Não rolou'
  ensure
    redirect_to admin_root_path
  end
end
