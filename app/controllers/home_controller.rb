class HomeController < ApplicationController

  # GET /
  def index
    @features = Feature.not_sound_check.enabled
  end

  # GET /projeto
  def about_us
  end

  # GET /passagem-de-som
  def sound_check_home
    @features = Feature.sound_check.enabled
  end

  # GET /passagem-de-som/lista
  def sound_check_list
    @events = SoundCheck.visible.order("date desc")
  end

  # GET /busca?q=....
  def search
    @search_term = params[:q]
    @search =
      SearchResult.search(@search_term)
                  .filtered_by_instrument(params[:instrument_id])
                  .filtered_by_genre(params[:genre_id])
    @artist_results = @search.artists.limit(15)
    @show_results = @search.shows.limit(9)
    @more_results = @search.more.limit(25)
  end

  # GET /privacidade
  def privacy
  end

  def live
    if @transmission = LiveTransmission.current
      redirect_to @transmission
    else
      redirect_to root_path
    end
  end

  def live_status
    render :json => LiveTransmission.live_status
  end

  private

  def search_params
    params.permit(:instrument_id, :genre_id)
  end

  def cache_key
    ["search-results", params.permit(:q, :instrument_id, :genre_id)]
  end
  helper_method :cache_key

end
