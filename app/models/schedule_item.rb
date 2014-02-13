class ScheduleItem < ActiveRecord::Base
  belongs_to :artist

  validates_presence_of :artist, :date, :description

  def self.current_items
    d = Date.current
    next_items = where("date >= ?", d).order("date").limit(3).to_a
    previous_items = where("date < ?", d).order("date desc").limit(4 - next_items.length).to_a
    previous_items.reverse + next_items
  end

end
