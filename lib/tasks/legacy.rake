require 'dotenv/tasks'

namespace :db do

  namespace :legacy do

    # Generates db/legacy/dump.yml file, containing
    # the data from the original legacy database
    task :dump => :dotenv do
      results = { artists: [] }
      artists_by_legacy_id = {}
      shows_by_legacy_id = {}
      interviews_by_legacy_id = {}
      video_chats_by_legacy_id = {}
      artists = legacy_sql("SELECT art_ID, Name, Text from ut_Artist")
      artists.group_by{ |a| a["Name"] }.each do |name, items|
        legacy_ids = items.map{ |i| i["art_ID"] }
        artist = {
          name: name,
          description: items.first["Text"],
          legacy_ids: legacy_ids
        }
        legacy_ids.each { |id| artists_by_legacy_id[id] = artist }
        results[:artists] << artist
      end
      shows = legacy_sql("SELECT sho_ID, art_ID, EventDate, Text from ut_Show")
      shows.each do |row|
        artist = artists_by_legacy_id[row['art_ID']]
        show = {
          legacy_id: row['sho_ID'],
          date: row['EventDate'].to_date.strftime("%Y-%m-%d"),
          description: row['Text']
        }
        artist[:shows] ||= []
        artist[:shows] << show
        shows_by_legacy_id[row['sho_ID']] = show
      end
      interviews = legacy_sql("SELECT int_ID, art_ID, EventDate, Text from ut_Interview")
      interviews.each do |row|
        artist = artists_by_legacy_id[row['art_ID']]
        interview = {
          legacy_id: row['int_ID'],
          date: row['EventDate'].to_date.strftime("%Y-%m-%d"),
          description: row['Text']
        }
        artist[:interviews] ||= []
        artist[:interviews] << interview
        interviews_by_legacy_id[row['int_ID']] = interview
      end
      video_chats = legacy_sql("SELECT vch_ID, art_ID, EventDate, Text from ut_VideoChat")
      video_chats.each do |row|
        artist = artists_by_legacy_id[row['art_ID']]
        video_chat = {
          legacy_id: row['vch_ID'],
          date: row['EventDate'].to_date.strftime("%Y-%m-%d"),
          description: row['Text']
        }
        artist[:video_chats] ||= []
        artist[:video_chats] << video_chat
        video_chats_by_legacy_id[row['vch_ID']] = video_chat
      end
      File.open("db/legacy/dump.yml", 'w') { |f| f.write(results.to_yaml) }
      File.open("db/legacy/seeds.yml", 'w') { |f| f.write(results.to_yaml) }
    end

    private

    def legacy_sql(command)
      require 'tiny_tds'
      sql = TinyTds::Client.new(host: ENV['LEGACY_SQL_HOST'],
                                username: ENV['LEGACY_SQL_USERNAME'],
                                password: ENV['LEGACY_SQL_PASSWORD'])
      sql.execute(command).to_a
    end

  end

end
