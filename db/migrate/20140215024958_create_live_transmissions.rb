class CreateLiveTransmissions < ActiveRecord::Migration
  def up
    create_table :live_transmissions do |t|
      t.date        :date,        null: false
      t.belongs_to  :artist,      null: false
      t.text        :description, null: false
      t.text        :band_members

      t.timestamps
    end
    add_index :live_transmissions, :date
    if wilson = Artist.find_by_slug("wilson-das-neves")
      LiveTransmission.create(date: '2014-02-17',
                              artist: wilson,
                              description: wilson.description)
    end
    if porto = Artist.find_by_slug("porto")
      LiveTransmission.create(date: '2014-02-24',
                              artist: porto,
                              description: porto.description)
    end
  end
  def down
    drop_table :live_transmissions
  end
end
