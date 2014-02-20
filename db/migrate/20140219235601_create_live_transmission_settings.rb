class CreateLiveTransmissionSettings < ActiveRecord::Migration
  def up
    create_table :live_transmission_settings do |t|
      t.time   :starts_at,   null: false
      t.time   :ends_at,     null: false

      t.timestamps
    end
    LiveTransmissionSettings.create!(starts_at: "18:50", ends_at: "22:00")
  end
  def down
    drop_table :live_transmission_settings
  end
end
