class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.belongs_to :featurable, polymorphic: true
      t.text       :description_override
      t.boolean    :enabled, null: false, default: false
      t.timestamps
    end
    add_index :features, :enabled
  end
end
