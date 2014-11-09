class Admin::HomeController < AdminController
  def dashboard
  end

  def sync_videos
    #rake  = "RAILS_ENV=#{Rails.env} "
    #rake += "bundle exec rake account:compulsory_migration[/tmp/#{params[:file_name]}] --trace "
    #rake += " &" # Run rake in a background process.

    #log_info rake

    #Kernel.system(rake)

    flash[:success] = 'Vídeos sincronizados.'
    redirect_to admin_root_path
  end

  def clear_cache
    #Dalli::Client.new.flush

    Rails.logger.info 'Start cache cleaning...'

    rake = 'RAILS_ENV=production bundle exec rake tmp:cache:clear --trace'
    Kernel.system(rake)

    Rails.logger.info 'Cache cleaned.'

    flash[:success] = 'Cache limpo.'
    redirect_to admin_root_path
  rescue => e
    Rails.logger.error e.message
  end
end
