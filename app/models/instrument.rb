class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :artists
  has_and_belongs_to_many :band_members
  has_many :songs, through: :band_members, inverse_of: :instruments
  has_many :shows, through: :songs, inverse_of: :instruments
end
