class SearchResult < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :genres

  scope :artists, -> { where(result_type: "Artist") }
  scope :shows, -> { where(result_type: "Show") }
  scope :more, -> { where(result_type: "More") }

  scope :search, -> (query) {
    where(%[(((setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."title"::text, ''))), 'A') || setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."content"::text, ''))), 'B')) @@ (plainto_tsquery('portuguese', f_unaccent(:query)))))], :query => query)
    .order(%[((ts_rank((setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."title"::text, ''))), 'A') || setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."content"::text, ''))), 'B')), (plainto_tsquery('portuguese', f_unaccent(#{sanitize(query)}))), 0))) DESC])
  }

  def self.genres_list
    joins(:genres)
      .group("genres.id, genres.name")
      .reorder("genres.name")
      .pluck("genres.id, genres.name, count(*)")
  end

  def self.instruments_list
    joins(:instruments)
      .group("instruments.id, instruments.name")
      .reorder("instruments.name")
      .pluck("instruments.id, instruments.name, count(*)")
  end

  def self.for(query, options = {})
    instrument = Instrument.find_by_id(options[:instrument_id]) if options[:instrument_id]
    genre = Genre.find_by_id(options[:genre_id]) if options[:genre_id]
    if instrument && genre
      inst = "select search_result_id from instruments_search_results "\
             "where instrument_id = :instrument_id"
      genr = "select search_result_id from genres_search_results where genre_id = :genre_id"
      scope = where("id in (#{inst}) or id in (#{genr})",
                    genre_id: genre.id, instrument_id: instrument.id)
    elsif instrument
      scope = instrument.search_results
    elsif genre
      scope = genre.search_results
    else
      scope = all
    end
    scope.search(query)
  end
end
