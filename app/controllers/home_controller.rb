class HomeController < ApplicationController

  # GET /
  def index
    @features = Feature.enabled
  end

  # GET /projeto
  def about_us
  end

  # GET /privacidade
  def privacy
  end

end
