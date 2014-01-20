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

end
