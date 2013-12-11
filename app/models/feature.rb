class Feature < ActiveRecord::Base
  belongs_to :featurable, polymorphic: true

  scope :enabled, -> { where(enabled: true) }

  def artist
    featurable.is_a?(Artist) ? featurable : featurable.artist
  end

  def date
    featurable.try(:date)
  end

  def description
    description_override || featurable.description
  end

end
