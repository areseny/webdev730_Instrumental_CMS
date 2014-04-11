namespace :gallery do

  task :fix => :environment do
    images = GalleryImage.where(fixed: false).to_a
    images.each do |img|
      begin
        GalleryImage.transaction do
          img.image.recreate_versions!
          img.update_attributes!(fixed: true)
        end
        puts "Fixed: #{img.image.url}"
      rescue Exception => e
        puts "Error: #{img.image.url}"
        puts e.message
        puts e.backtrace
        puts "======================="
      end
    end
  end

end
