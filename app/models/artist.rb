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
  scope :visible, -> { where(id: Event.pluck(:artist_id)) }
  scope :current, -> { where(id: Event.current.uniq.pluck(:artist_id)) }
  scope :legacy, -> { where(id: Event.legacy.uniq.pluck(:artist_id)) }

  mount_uploader :banner, BannerUploader
  mount_uploader :thumbnail, ThumbnailUploader

  def site_events
    events.visible.site.last_first
  end

  def tv_events
    events.visible.tv.last_first
  end

  def legacy_events
    events.visible.legacy.last_first
  end

  def to_param
    slug
  end

  def self.list(letter = nil)
    list = current.order(:first_letter)
    letter = "~" if letter == "_"
    list = list.where(first_letter: letter) if letter
    list
  end
end
