class Admin::AuthenticationController < AdminController
  skip_before_filter :authenticate

  def login_form
  end

  def login
    if params[:username] == ENV['ADMIN_USERNAME'] && params[:password] == ENV['ADMIN_PASSWORD']
      session[:admin] = true
      redirect_to admin_root_path
    else
      flash.now[:danger] = "admin.login_failure"
      render :login_form
    end
  end

  def logoff
    session[:admin] = nil
    redirect_to admin_login_path
  end

end
