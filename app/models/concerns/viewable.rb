module Viewable
  extend ActiveSupport::Concern

  included do
    has_one :video, as: :viewable, dependent: :destroy
    before_save :parse_timecodes_text
  end

  def timecodes_text
    if video
      video.timecodes.map do |tc|
        "#{time_format(tc.seconds)} #{tc.description}"
      end.join("\n")
    end
  end

  def timecodes_text=(value)
    @timecodes_text = value
  end

  private

  def time_format(seconds)
    min = "%02d" % (seconds / 60)
    sec = "%02d" % (seconds % 60)
    "#{min}:#{sec}"
  end

  def parse_timecodes_text
    if @timecodes_text && video
      video.timecodes.delete_all
      @timecodes_text.scan(/^(\d\d?):(\d\d?) (.*)$/).each do |min, sec, desc|
        seconds = min.to_i * 60 + sec.to_i
        video.timecodes.create!(seconds: seconds, description: desc)
      end
    end
  end

end
