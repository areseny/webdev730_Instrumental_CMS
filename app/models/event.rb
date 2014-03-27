class Event < ActiveRecord::Base
  belongs_to :artist, inverse_of: :events
  include Searchable

  SiteTypes   = %w(Show Interview VideoChat)
  TvTypes     = %w(TvShow SoundCheck)
  LegacyTypes = %w(LegacyShow LegacyTvShow)

  scope :site,    -> { where(type: SiteTypes) }
  scope :tv,      -> { where(type: TvTypes) }
  scope :current, -> { where.not(type: LegacyTypes) }
  scope :legacy,  -> { where(type: LegacyTypes) }
  scope :visible, -> { where(visible: true) }
  scope :sorted,  -> { order("date desc, sort_order asc") }

  validates :date, :presence => true,
                   :uniqueness => { :scope => :type }
  validates :artist, :presence => true
  validates :description, :presence => true

  def self.related_content(artist, event = nil)
    if(event)
      artist.events.visible.where.not(id: event).sorted
    else
      artist.events.visible.sorted
    end
  end

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

  def human_name
    self.class.model_name.human
  end

  def article_title
    artist.name + " | " + human_name
  end

  def disqus_title
    "#{human_name}: #{artist.name} (#{I18n.l(date, format: :month)})"
  end

  def title
    "#{human_name} com #{artist.name} em #{I18n.l(date, format: :brief)}"
  end

  def search_title
    title
  end

  def disqus_identifier
    "#{artist.slug}/#{slug}"
  end

  def self.next_debut
    where.not(debuts_at: nil)
      .order("debuts_at")
      .where("debuts_at >= ?", Date.current).first ||
      where.not(debuts_at: nil).order("debuts_at desc").first
  end

  def search_content
    description
  end

  def twitter_text
    "Instrumental SESC Brasil: #{title}"
  end

  def email_subject
    "Instrumental SESC Brasil: #{title}"
  end

  def email_body
    "Instrumental SESC Brasil: #{title}\n\nhttp://instrumentalsescbrasil.org.br/artistas/#{artist.slug}/#{slug}"
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
  before_save :set_sort_order

  def generate_event_slug
    date_slug = I18n.l(date, format: "%d-%B-%Y")
    self.slug ||= I18n.t("slugs.#{type.underscore}") + "-em-" + date_slug.parameterize
  end
  before_create :generate_event_slug

end
