class Admin::ShowsController < AdminController

  def typeahead
    @shows = Show.all
  end

end
