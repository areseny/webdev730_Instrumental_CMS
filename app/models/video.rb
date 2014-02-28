class Video < ActiveRecord::Base
  belongs_to :viewable, polymorphic: true
  has_many :timecodes, dependent: :delete_all

  def url
    "http://www.youtube.com/watch?v=#{youtube_id}"
  end

  private

  def update_view_count
    if artist = viewable.try(:artist)
      artist.update_view_count!
    end
  end
  after_save :update_view_count

end
