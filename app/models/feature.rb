class Feature < ActiveRecord::Base
  scope :enabled, -> { where(enabled: true).order(:priority) }

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  validates :banner, presence: true

  mount_uploader :banner, FeatureBannerUploader

end
