class Event < ActiveRecord::Base
  belongs_to :artist, inverse_of: :events
  scope :site, -> { where(type: %w(Show Interview VideoChat)) }
  scope :tv, -> { where(type: %w(TvShow SoundCheck)) }
  scope :current, -> { where.not(type: %w(LegacyShow LegacyTvShow)) }
  scope :legacy, -> { where(type: %w(LegacyShow LegacyTvShow)) }
  scope :visible, -> { where(visible: true) }
  scope :last_first, -> { order("date desc") }

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

  def article_title
    artist.name + " | " + self.class.model_name.human
  end

  def self.next_debut
    order("debuts_at").where("debuts_at >= ?", Date.current).first ||
      order("debuts_at desc").first
  end
end
