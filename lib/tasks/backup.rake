namespace :db do

  task :backup do
    dbname = "instrumental_sesc_brasil_development"
    system "pg_dump #{dbname} > tmp/dump.sql"
  end

  task :restore do
    dbname = "instrumental_sesc_brasil_development"
    system "psql -d #{dbname} -c \"drop schema public cascade; create schema public\""
    system "cat tmp/dump.sql | psql -d #{dbname}"
  end

end
