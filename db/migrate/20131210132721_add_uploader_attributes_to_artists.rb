class AddUploaderAttributesToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :thumbnail, :string
    add_column :artists, :banner, :string
    add_column :artists, :banner_width, :integer
    add_column :artists, :banner_height, :integer
  end
end
