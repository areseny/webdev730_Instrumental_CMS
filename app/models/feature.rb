class Feature < ActiveRecord::Base
  scope :enabled, -> { where(enabled: true).order(:priority) }

  # TOSCO:
  scope :sound_check, -> { where("url like '%passagem-de-som%'") }
  scope :not_sound_check, -> { where("url not like '%passagem-de-som%'") }

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  validates :banner, presence: true

  mount_uploader :banner, FeatureBannerUploader

end
