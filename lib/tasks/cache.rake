namespace :tmp do

  task :clear_dalli_store do
    Rails.logger.info 'Start cache cleaning...'
    Dalli::Client.new.flush
    Rails.logger.info 'Cache cleaned.'
  end

  namespace :cache do
    task :clear => :clear_dalli_store
  end

end
