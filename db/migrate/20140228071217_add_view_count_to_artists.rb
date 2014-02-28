class AddViewCountToArtists < ActiveRecord::Migration
  def up
    add_column :artists, :view_count, :integer, null: false, default: 0
    Artist.all.each(&:update_view_count!)
  end
  def down
    remove_column :artists, :view_count
  end
end
