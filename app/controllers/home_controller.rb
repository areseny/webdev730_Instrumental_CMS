class HomeController < ApplicationController

  # GET /
  def index
    @feature = Feature.first
  end

  # GET /projeto
  def about_us
  end

  # GET /privacidade
  def privacy
  end

end
