class LiveTransmissionSettings < ActiveRecord::Base


  def self.current
    first
  end

end
