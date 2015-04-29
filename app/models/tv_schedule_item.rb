require 'csv'

class TvScheduleItem < ActiveRecord::Base
  validates_presence_of :starts_at, :description

  class << self
    def current_or_last_day
      where("date_trunc('day', starts_at) <= ?", Date.current)
        .maximum("date_trunc('day', starts_at)").try :to_date
    end

    def for_day(day)
      where("date_trunc('day', starts_at) = ?", day.to_date).order(:starts_at)
    end

    def import(file)
      rows = CSV.read(file)
      total_imported = 0

      transaction do
        rows.each_with_index do |row, i|
          description = row.pop.strip
          starts_at = Time.parse(row.join(' ').strip)
          item = where(starts_at: starts_at).first_or_initialize(description: description)
          total_imported += 1 if item.save
        end
      end

      total_imported
    end
  end
end
