class Song < ActiveRecord::Base
  include Viewable
  belongs_to :playlistable, polymorphic: true
  delegate :artist, to: :playlistable
  has_and_belongs_to_many :genres
  has_many :band_members, dependent: :destroy
  has_many :instruments, -> { uniq }, through: :band_members, inverse_of: :songs
  acts_as_list scope: [:playlistable_type, :playlistable_id]

  validates :title, :presence => true
  validates :composer, :presence => true

  scope :ordered, -> { order(:position) }
  scope :top, -> (size) { joins(:video).order("videos.views desc").limit(size) }

  def self.search(q)
    joins('inner join events on events.id = songs.playlistable_id')
    .joins('inner join artists on artists.id = events.artist_id')
    .where("artists.name ilike :q OR songs.title ilike :q", q: "%#{q}%")
  end

  def title_with_composer
    composer.present? ? "#{title} (#{composer})" : title
  end

  def video_thumbnail
    video.small_thumbnail if video
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def opengraph_title
    "#{artist.name}: #{title} | Instrumental SESC Brasil"
  end

end
