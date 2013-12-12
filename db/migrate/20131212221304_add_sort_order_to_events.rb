class AddSortOrderToEvents < ActiveRecord::Migration
  def up
    add_column :events, :sort_order, :integer, null: false, default: 0
    Event.where(type: "Show").update_all(sort_order: 1)
    Event.where(type: "Interview").update_all(sort_order: 2)
    Event.where(type: "VideoChat").update_all(sort_order: 3)
    Event.where(type: "SoundCheck").update_all(sort_order: 4)
    Event.where(type: "TvShow").update_all(sort_order: 5)
    Event.where(type: "LegacyTvShow").update_all(sort_order: 6)
    Event.where(type: "LegacyShow").update_all(sort_order: 7)
    add_index :events, :sort_order
  end
  def down
    remove_index :events, :sort_order
    remove_column :events, :sort_order
  end
end
