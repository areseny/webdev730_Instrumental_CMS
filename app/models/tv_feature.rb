class TvFeature < ActiveRecord::Base
  belongs_to :show, dependent: :delete
  has_one :artist, through: :show

  validates :show, :presence => true
  validates :description, :presence => true
  validates :debuts_at, :presence => true

  def self.current
    where('debuts_at > ?', DateTime.current).order(:debuts_at).first
  end
end
