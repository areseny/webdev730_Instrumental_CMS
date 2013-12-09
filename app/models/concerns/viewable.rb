module Viewable
  extend ActiveSupport::Concern

  included do
    has_one :video, as: :viewable, dependent: :destroy
  end

end
