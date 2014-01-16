namespace :db do

  task :seed_from_fixtures => :environment do
    require 'active_record/fixtures'
    tables = %w(
      instruments genres artists gallery_images events
      songs band_members videos timecodes features
      tv_schedule_items
    )
    ActiveRecord::FixtureSet.create_fixtures("db/seeds", tables)
  end

  task :seed => :seed_from_fixtures

end
