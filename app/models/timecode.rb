class Timecode < ActiveRecord::Base
  belongs_to :video, inverse_of: :timecodes
  default_scope -> { order(:seconds) }
end
