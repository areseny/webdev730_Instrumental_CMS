class CreateScheduleItems < ActiveRecord::Migration
  def up
    create_table :schedule_items do |t|
      t.date :date, null: false
      t.references :artist, null: false
      t.text :description, null: false

      t.timestamps
    end
    add_index :schedule_items, :date
    Show.all.each do |show|
      ScheduleItem.create!(date: show.date, artist: show.artist, description: show.description)
    end
  end
  def down
    drop_table :schedule_items
  end
end
