module Filterable
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :instruments
    has_and_belongs_to_many :genres
  end

  module ClassMethods
    def filtered_by_instrument(instrument_id)
      if instrument_id
        joins(:instruments).where(:instruments => { :id => instrument_id })
      else
        all
      end
    end

    def filtered_by_genre(genre_id)
      if genre_id
        joins(:genres).where(:genres => { :id => genre_id })
      else
        all
      end
    end

    def genres_list
      joins(:genres)
        .group("genres.id, genres.name")
        .reorder("genres.name")
        .pluck("genres.id, genres.name, count(*)")
    end

    def instruments_list
      joins(:instruments)
        .group("instruments.id, instruments.name")
        .reorder("instruments.name")
        .pluck("instruments.id, instruments.name, count(*)")
    end
  end

end
