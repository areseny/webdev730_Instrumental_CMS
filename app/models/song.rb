class Song < ActiveRecord::Base
  include Viewable
  belongs_to :playlistable, polymorphic: true, inverse_of: :songs
  delegate :artist, to: :playlistable
  has_and_belongs_to_many :genres
  has_many :band_members, dependent: :destroy
  has_many :instruments, -> { uniq }, through: :band_members, inverse_of: :songs
  acts_as_list scope: [:playlistable_type, :playlistable_id]
end
