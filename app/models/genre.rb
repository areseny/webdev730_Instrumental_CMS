class Genre < ActiveRecord::Base
  has_and_belongs_to_many :songs
  has_and_belongs_to_many :search_results
end
