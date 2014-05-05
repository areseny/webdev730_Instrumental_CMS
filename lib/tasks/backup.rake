namespace :db do

  task :backup do
    env = ENV['RAILS_ENV'] || 'development'
    dbname = "instrumental_sesc_brasil_#{env}"
    system "pg_dump #{dbname} > tmp/dump.sql"
  end

  task :restore do
    env = ENV['RAILS_ENV'] || 'development'
    dbname = "instrumental_sesc_brasil_#{env}"
    system "psql -d #{dbname} -c \"drop schema public cascade; create schema public\""
    system "cat tmp/dump.sql | psql -d #{dbname}"
  end

  # Backup from live system:
  # heroku pgbackups:capture
  # curl -o db/xxx.dump `heroku pgbackups:url`
  # pg_restore --verbose --clean --no-acl --no-owner -h localhost -U instrumental_sesc_brasil -d instrumental_sesc_brasil_development db/xxx.dump
  # rm -rf tmp/cache

end
