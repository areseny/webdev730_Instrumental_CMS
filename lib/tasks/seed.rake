namespace :db do

  task :seed_from_fixtures => :environment do
    require 'active_record/fixtures'
    tables = %w(
      instruments genres artists events
      songs band_members videos timecodes features
      tv_schedule_items
    )
    ActiveRecord::FixtureSet.create_fixtures("db/seeds", tables)
  end

  task :seed_gallery => :environment do
    require 'active_record/fixtures'
    ActiveRecord::FixtureSet.create_fixtures("db/seeds", %w(gallery_images))
    GalleryImage.order(:id).all.each do |gallery_image|
      gallery_image.image.recreate_versions!(:thumb, :preview)
      puts gallery_image.image.url
    end
  end

  task :seed => :seed_from_fixtures

end
