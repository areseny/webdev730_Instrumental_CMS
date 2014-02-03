namespace :schedule do

  task :import => :environment do
    TvScheduleItem.transaction do
      STDIN.each_line do |line|
        date, description = line.split(',')
        date = Time.strptime(date, "%d/%m/%Y %H:%M")
        TvScheduleItem.create!(starts_at: date, description: description)
        puts "#{date}: #{description}"
      end
    end
  end

  task :import_debuts => :environment do
    Show.transaction do
      STDIN.each_line do |line|
        date, slug = line.split(',')
        date = Time.strptime(date, "%d/%m/%Y %H:%M")
        artist = Artist.find_by_slug(slug.strip)
        if !artist
          puts "Artist not found: #{slug}"
          exit
        end
        show = artist.shows.last
        show.update_attributes!(debuts_at: date)
      end
    end
  end

end
