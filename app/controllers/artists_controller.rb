class ArtistsController < ApplicationController
  # GET /artistas(/letra/:letter)
  def index
    @artists =
      Artist.list(params[:letter])
            .filtered_by_genre(params[:genre_id])
            .filtered_by_instrument(params[:instrument_id])
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

  # GET ui/artist.aspx?id=:id
  def legacy_artist
    @artist = Artist.where("? = ANY(legacy_ids)", params[:id]).first
    @artist or raise ActiveRecord::RecordNotFound
    redirect_to artist_url(@artist), :status => :moved_permanently
  end

  # GET /artistas/:id
  def show
    @artist = Artist.find_by_slug!(params[:id])
  end
end
