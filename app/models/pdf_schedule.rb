class PdfSchedule < ActiveRecord::Base
  mount_uploader :file, PdfScheduleUploader

  validates :available_date, presence: true, uniqueness: true
  validates :file, presence: true

  def self.current
    where('available_date <= ?', Date.current).order('available_date desc').first
  end
end
