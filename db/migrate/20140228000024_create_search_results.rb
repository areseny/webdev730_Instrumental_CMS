class CreateSearchResults < ActiveRecord::Migration
  def up
    create_table :search_results do |t|
      t.references :searchable, polymorphic: true, null: false
      t.string :result_type, null: false
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end
    add_index :search_results, :result_type
  end
  def down
    drop_table :search_results
  end
end
