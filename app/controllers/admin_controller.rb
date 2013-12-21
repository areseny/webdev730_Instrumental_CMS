class AdminController < ApplicationController
  before_filter :authenticate

  private

  def authenticate
    redirect_to admin_login_path unless authenticated?
  end

  def authenticated?
    session[:admin].present?
  end
  helper_method :authenticated?

end
