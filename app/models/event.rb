class Event < ActiveRecord::Base
  belongs_to :artist, inverse_of: :events
  scope :site, -> { where(type: %w(Show Interview VideoChat)) }
  scope :tv, -> { where(type: %w(TvShow SoundCheck)) }
  scope :current, -> { where.not(type: %w(LegacyShow LegacyTvShow)) }
  scope :legacy, -> { where(type: %w(LegacyShow LegacyTvShow)) }

  def video_thumbnail
    video.small_thumbnail if video
  end

  def views
    video.try(:views) || 0
  end

  def comments
    video.try(:comments) || 0
  end

  def to_param
    slug
  end
end
