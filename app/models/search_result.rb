class SearchResult < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
  include Filterable

  scope :artists, -> { where(result_type: "Artist") }
  scope :shows, -> { where(result_type: "Show") }
  scope :more, -> { where(result_type: "More") }

  scope :search, -> (query) {
    where(%[(((setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."title"::text, ''))), 'A') || setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."content"::text, ''))), 'B')) @@ (plainto_tsquery('portuguese', f_unaccent(:query)))))], :query => query)
    .order(%[((ts_rank((setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."title"::text, ''))), 'A') || setweight(to_tsvector('portuguese', f_unaccent(coalesce("search_results"."content"::text, ''))), 'B')), (plainto_tsquery('portuguese', f_unaccent(#{sanitize(query)}))), 0))) DESC])
  }
end
