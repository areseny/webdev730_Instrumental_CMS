namespace :tmp do

  task :clear_dalli_store do
    Dalli::Client.new.flush
  end

  namespace :cache do
    task :clear => :clear_dalli_store
  end

end
