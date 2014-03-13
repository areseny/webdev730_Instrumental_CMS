module Searchable
  extend ActiveSupport::Concern

  included do
    has_one :search_result, as: :searchable, dependent: :delete
    after_save :update_search_result
  end

  def search_title
  end

  def search_content
  end

  def search_instruments
  end

  def search_genres
  end

  def search_result_type
  end

  def build_search_result
    SearchResult.new.tap do |result|
      result.title = search_title
      result.content = search_content
      result.result_type = search_result_type || "More"
      instruments = (self.search_instruments || []).uniq
      genres = (self.search_genres || []).uniq
      if instruments.any?
        result.instruments << instruments
        result.content << " " << instruments.map(&:name).join(' ')
      end
      if genres.any?
        result.genres << genres
        result.content << " " << genres.map(&:name).join(' ')
      end
    end
  end

  def update_search_result
    search_result.destroy if search_result
    self.search_result = build_search_result if visible
  end

end
