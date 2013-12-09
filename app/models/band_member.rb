class BandMember < ActiveRecord::Base
  belongs_to :song, inverse_of: :band_members
  has_and_belongs_to_many :instruments
end
