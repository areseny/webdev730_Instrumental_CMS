class CreatePdfSchedules < ActiveRecord::Migration
  def change
    create_table :pdf_schedules do |t|
      t.date    :available_date, null: false
      t.string  :file,           null: false

      t.timestamps
    end
    add_index :pdf_schedules, :available_date, unique: true
  end
end
