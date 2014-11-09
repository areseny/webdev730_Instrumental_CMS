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

    rake = 'rake tmp:cache:clear --app instrumental-sesc-brasil'
    Kernel.system(rake)

    flash[:success] = 'Cache limpo.'
    redirect_to admin_root_path
  end
end
