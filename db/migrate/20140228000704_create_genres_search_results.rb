class CreateGenresSearchResults < ActiveRecord::Migration
  def change
    create_table :genres_search_results, id: false do |t|
      t.belongs_to :search_result,  null: false
      t.belongs_to :genre,          null: false
    end
    add_index :genres_search_results, [:genre_id, :search_result_id],
              name: "unique_genres_search_results", unique: true
  end
end
