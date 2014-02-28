class CreateInstrumentsSearchResults < ActiveRecord::Migration
  def change
    create_table :instruments_search_results, id: false do |t|
      t.belongs_to :search_result,  null: false
      t.belongs_to :instrument,     null: false
    end
    add_index :instruments_search_results, [:instrument_id, :search_result_id],
              name: "unique_instruments_search_results", unique: true
  end
end
