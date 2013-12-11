class CreateTvScheduleItems < ActiveRecord::Migration
  def change
    create_table :tv_schedule_items do |t|
      t.datetime :starts_at, null: false
      t.string :description, null: false

      t.timestamps
    end
    add_index :tv_schedule_items, :starts_at
  end
end
