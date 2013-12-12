class Video < ActiveRecord::Base
  belongs_to :viewable, inverse_of: :video, polymorphic: true
  has_many :timecodes, dependent: :delete_all

  def url
    "http://www.youtube.com/watch?v=#{youtube_id}"
  end
end
