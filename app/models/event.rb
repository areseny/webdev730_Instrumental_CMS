class Event < ActiveRecord::Base
  belongs_to :artist, inverse_of: :events
  scope :site, -> { where(type: %w(Show Interview VideoChat)) }
  scope :tv, -> { where(type: %w(TvShow SoundCheck)) }
  scope :legacy, -> { where(type: %w(LegacyShow LegacyTvShow)) }
end
