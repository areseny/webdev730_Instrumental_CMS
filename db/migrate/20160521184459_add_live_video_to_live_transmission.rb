class AddLiveVideoToLiveTransmission < ActiveRecord::Migration
  def change
    add_column :live_transmissions, :live_video, :text
  end
end
