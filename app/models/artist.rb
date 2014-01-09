class Artist < ActiveRecord::Base
  has_many :events, dependent: :destroy
  has_many :shows
  has_many :interviews
  has_many :video_chats
  has_many :tv_shows
  has_many :sound_checks
  has_many :legacy_tv_shows
  has_many :legacy_shows
  has_many :songs, through: :shows
  has_many :legacy_songs, through: :legacy_shows, class_name: Song
  has_many :genres, through: :songs
  has_and_belongs_to_many :instruments
  has_many :gallery, class_name: GalleryImage, inverse_of: :artist

  scope :visible, -> { joins(:events).where(events:{ visible: true }).uniq }
  scope :current, -> { joins(:events).where.not(events:{ type: Event::LegacyTypes }).uniq }
  scope :legacy,  -> { joins(:events).where(events:{ type: Event::LegacyTypes }).uniq }

  mount_uploader :banner, BannerUploader
  mount_uploader :thumbnail, ThumbnailUploader

  def site_events
    events.site.visible.sorted
  end

  def tv_events
    events.tv.visible.sorted
  end

  def legacy_events
    events.legacy.visible.sorted
  end

  def to_param
    slug
  end

  def disqus_title
    "Artista: #{name}"
  end

  def disqus_identifier
    slug
  end

  def dates
    events.pluck('distinct date')
  end

  def self.list(letter = nil)
    list = current.visible.order(:first_letter, :sort_name)
    letter = "~" if letter == "_"
    list = list.where(first_letter: letter) if letter
    list
  end
end
