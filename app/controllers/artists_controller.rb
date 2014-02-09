class ArtistsController < ApplicationController

  # GET /artistas(/letra/:letter)
  def index
    @artists = Artist.list(params[:letter])
  end

  def export
    respond_to do |format|
      format.json do
        artists = Artist.order(:first_letter, :sort_name).to_a.map do |artist|
          data = artist.attributes.slice(*%w(
            name slug description sort_name first_letter
            facebook_page twitter_widget_id legacy_ids))
          data.merge("instruments" => artist.instruments.pluck(:name))
        end
        render json: artists
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
