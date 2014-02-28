class Admin::GenresController < AdminController

  def index
    @genres = Genre.pluck(:name)
    render :json => @genres
  end

end
