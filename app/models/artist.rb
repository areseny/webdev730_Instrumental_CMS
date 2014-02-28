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
  include Searchable

  scope :visible, -> { joins(:events).where(events:{ visible: true }).uniq }
  scope :current, -> { joins(:events).where.not(events:{ type: Event::LegacyTypes }).uniq }
  scope :legacy,  -> { joins(:events).where(events:{ type: Event::LegacyTypes }).uniq }

  mount_uploader :banner, BannerUploader
  mount_uploader :thumbnail, ThumbnailUploader

  def site_events
    events.site.visible.sorted
  end

  def visible
    events.where(visible: true).any?
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
    events.order(:date).pluck('distinct date')
  end

  def self.list(letter = nil)
    list = current.visible.order(:first_letter, :sort_name)
    letter = "~" if letter == "_"
    list = list.where(first_letter: letter) if letter
    list
  end

  def instrument_names
    instruments.map(&:name).join(",")
  end

  def instrument_names=(value)
    @instrument_names = value
  end

  def search_title
    name
  end

  def search_content
    description
  end

  def search_instruments
    instruments.to_a
  end

  def search_genres
    genres.to_a
  end

  def search_result_type
    "Artist"
  end

  private

  def set_instruments_before_saving
    if @instrument_names
      instruments.clear
      self.instruments = @instrument_names.downcase.split(",").map do |n|
        Instrument.where(name: n).first_or_initialize
      end
    end
  end
  before_save :set_instruments_before_saving

  def generate_artist_slug
    candidate = the_slug = name.parameterize
    counter = 1
    while self.class.exists?(slug: candidate)
      counter += 1
      candidate = "#{the_slug}-#{counter}"
    end
    self.slug = candidate
  end
  before_create :generate_artist_slug

  def set_sort_name
    self.sort_name ||= name.gsub(/^(a|as|o|os|à|\d+)?\s/i, "").camelize
  end
  before_create :set_sort_name

  def set_first_letter
    self.first_letter ||= I18n.transliterate(name)[0].downcase.gsub(/[^a-z]/, "~")
  end
  before_create :set_first_letter

end
