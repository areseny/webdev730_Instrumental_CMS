class CreateTvFeatures < ActiveRecord::Migration
  def up
    create_table :tv_features do |t|
      t.datetime :debuts_at, null: false
      t.references :show, null: false
      t.text :description, null: false

      t.timestamps
    end
    add_index :tv_features, :debuts_at
    tv_features_seeds = [
      [ "22/12/2013 21:30", 527808900  ],
      [ "12/01/2014 21:30", 20438186   ],
      [ "19/01/2014 21:30", 565429295  ],
      [ "26/01/2014 21:30", 996400627  ],
      [ "01/02/2014 21:30", 984967901  ],
      [ "09/02/2014 21:30", 1065403473 ],
      [ "16/02/2014 21:30", 573177568  ],
      [ "23/02/2014 21:30", 21795840   ],
      [ "02/03/2014 21:30", 591653984  ],
      [ "09/03/2014 21:30", 1055577843 ],
      [ "16/03/2014 21:30", 1037242013 ],
      [ "23/03/2014 21:30", 880905179  ],
      [ "30/03/2014 21:30", 85143510   ],
      [ "06/04/2014 21:30", 1050269583 ],
      [ "13/04/2014 21:30", 342570913  ],
      [ "20/04/2014 21:30", 974619475  ],
      [ "27/04/2014 21:30", 321689302  ],
    ]
    tv_features_seeds.each do |debuts_at, show_id|
      show = Show.find(show_id)
      TvFeature.create!(debuts_at: debuts_at, show_id: show_id,
                        description: show.artist.description)
    end
  end
  def down
    drop_table :tv_features
  end
end
