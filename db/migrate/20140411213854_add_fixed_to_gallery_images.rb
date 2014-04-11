class AddFixedToGalleryImages < ActiveRecord::Migration
  def change
    add_column :gallery_images, :fixed, :boolean, null: false, default: false
  end
end
