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
    rake = "RAILS_ENV=#{Rails.env} bundle exec rake tmp:cache:clear --trace &"
    Kernel.system(rake)

    flash[:success] = 'Cache limpo.'
  rescue => e
    Rails.logger.error e.message
    flash[:error] = 'Não rolou'
  ensure
    redirect_to admin_root_path
  end
end
