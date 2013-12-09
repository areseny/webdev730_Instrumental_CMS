module Playlistable
  extend ActiveSupport::Concern

  included do
    has_many :songs, as: :playlistable, dependent: :destroy
    has_many :genres, through: :songs
    has_many :band_members, through: :songs
    has_many :videos, through: :songs
    has_many :instruments, -> { uniq }, through: :band_members
  end

end
