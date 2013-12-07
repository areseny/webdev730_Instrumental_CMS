class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def process_error(error)
    if request.xhr?
      flash.now[:error] = "server_error"
      render :error, format: :js
      if Rails.env.development?
        logger.error error
        logger.error error.backtrace.join("\n")
      else
        # TODO: Notify Airbrake
      end
    else
      raise error
    end
  end
  rescue_from ::Exception, with: :process_error

end
