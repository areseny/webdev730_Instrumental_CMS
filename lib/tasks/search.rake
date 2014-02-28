namespace :search do

  task :rebuild => :environment do
    Artist.all.each(&:update_search_result)
    Event.all.each(&:update_search_result)
  end

end
