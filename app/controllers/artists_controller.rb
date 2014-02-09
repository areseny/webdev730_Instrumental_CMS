class ArtistsController < ApplicationController

  # GET /artistas(/letra/:letter)
  def index
    @artists = Artist.list(params[:letter])
  end

  def export
    respond_to do |format|
      format.json do
        attrs = %w(
          name slug description sort_name first_letter
          facebook_page twitter_widget_id legacy_ids )
        artists = Artist.order(:first_letter, :sort_name).select(*attrs)
        render :json => artists.map { |a| a.attributes.slice(*attrs) }
      end
    end
  end

  # GET /artistas(/memoria)
  def legacy
    @artists = Artist.legacy
  end

  # GET /artistas/:id
  def show
    @artist = Artist.find_by_slug!(params[:id])
  end

end
