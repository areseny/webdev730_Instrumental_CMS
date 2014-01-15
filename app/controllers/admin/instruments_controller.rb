class Admin::InstrumentsController < AdminController

  def index
    @instruments = Instrument.pluck(:name)
    render :json => @instruments
  end

end
