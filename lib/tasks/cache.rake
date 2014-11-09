namespace :tmp do

  task :clear_dalli_store do
    logger.info 'Start cache cleaning...'
    Dalli::Client.new.flush
    logger.info 'Cache cleaned.'
  end

  namespace :cache do
    task :clear => :clear_dalli_store
  end

end
