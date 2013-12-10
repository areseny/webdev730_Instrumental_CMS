class GalleryImage < ActiveRecord::Base
  belongs_to :artist, inverse_of: :gallery
  acts_as_list scope: :artist_id
  mount_uploader :image, GalleryUploader
end
