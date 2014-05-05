class TvFeature < ActiveRecord::Base
  belongs_to :show
  has_one :artist, through: :show

  validates :show, :presence => true
  validates :description, :presence => true
  validates :debuts_at, :presence => true

  def self.current
    where('debuts_at > ?', DateTime.current).order(:debuts_at).first
  end

  def self.current_items
    d = Date.current
    next_items = where("debuts_at >= ?", d).order("debuts_at").limit(3).to_a
    previous_items = where("debuts_at < ?", d)
                     .order("debuts_at desc").limit(4 - next_items.length).to_a
    previous_items.reverse + next_items
  end
end
