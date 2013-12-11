class TvScheduleItem < ActiveRecord::Base

  def self.current_or_last_day
    where("date_trunc('day', starts_at) <= ?", Date.current)
      .maximum("date_trunc('day', starts_at)").try :to_date
  end

  def self.for_day(day)
    where("date_trunc('day', starts_at) = ?", day.to_date).order(:starts_at)
  end

end
