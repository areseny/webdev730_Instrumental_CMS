class CreateGalleryImages < ActiveRecord::Migration
  def change
    create_table :gallery_images do |t|
      t.belongs_to  :artist,    null: false
      t.string      :image,     null: false
      t.integer     :width,     null: false, default: 0
      t.integer     :height,    null: false, default: 0
      t.integer     :position,  default: 0

      t.timestamps
    end
    add_index :gallery_images, [:artist_id, :position], unique: true
  end
end
