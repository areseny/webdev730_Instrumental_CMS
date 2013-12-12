class AddDebutsAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :debuts_at, :datetime
    add_index :events, :debuts_at
  end
end
