class Event < ActiveRecord::Base
  belongs_to :artist, inverse_of: :events
  before_create :set_sort_order

  SiteTypes   = %w(Show Interview VideoChat)
  TvTypes     = %w(TvShow SoundCheck)
  LegacyTypes = %w(LegacyShow LegacyTvShow)

  scope :site,    -> { where(type: SiteTypes) }
  scope :tv,      -> { where(type: TvTypes) }
  scope :current, -> { where.not(type: LegacyTypes) }
  scope :legacy,  -> { where(type: LegacyTypes) }
  scope :visible, -> { where(visible: true) }
  scope :sorted,  -> { order("sort_order, date desc") }

  def video_thumbnail
    video.small_thumbnail if video
  end

  def views
    video.try(:views) || 0
  end

  def comments
    video.try(:comments) || 0
  end

  def timecoded?
    false
  end

  def playlist?
    false
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

  private

  def set_sort_order
    self.sort_order = case type
    when "Show" then 1
    when "Interview" then 2
    when "VideoChat" then 3
    when "SoundCheck" then 4
    when "TvShow" then 5
    when "LegacyTvShow" then 6
    when "LegacyShow" then 7
    end
  end
end
