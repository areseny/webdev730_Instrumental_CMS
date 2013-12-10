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

    # Merges db/legacy/dump.yml with db/legacy/v0.1.yml
    #  (obtained from the v0.1 site, contains facebook and twitter info)
    # to produce /db/legacy/merged.yml
    task :merge do
      data = YAML.load_file(File.expand_path("db/legacy/dump.yml"))
      artists_by_name = index_artists_by_name(data)
      exports = YAML.load_file(File.expand_path("db/legacy/v0.1.yml"))
      exports.each do |row|
        artist = artists_by_name[row[:name]]
        if !artist
          puts "Artist not found! #{row[:name]}"
          exit
        else
          artist[:facebook_page] = row[:facebook_page]
          artist[:twitter_widget_id] = row[:twitter_widget_id]
        end
      end
      File.open("db/legacy/merged.yml", 'w') { |f| f.write data.to_yaml }
      File.open("db/legacy/seeds.yml", 'w') { |f| f.write data.to_yaml }
    end

    # Downloads all the artists images from the v0.1 site (from db/legacy/v0.1.yml)
    # and put into /tmp/legacy/images
    task :get_images do
      exports = YAML.load_file(File.expand_path("db/legacy/v0.1.yml"))
      exports.each do |row|
        artist_folder = "tmp/legacy/images/#{artist[:name]}"
        system "mkdir -p \"#{artist_folder}\""
        if !(row[:banner] =~ /no-banner/)
          system "wget #{row[:banner]} -O \"#{artist_folder}/banner.jpg\""
        end
        if !(row[:thumbnail] =~ /no-thumbnail/)
          system "wget #{row[:thumbnail]} -O \"#{artist_folder}/thumbnail.jpg\""
        end
        row[:gallery].each_with_index do |url, i|
          system "wget #{url} -O \"#{artist_folder}/gallery_#{i}.jpg\""
        end
      end
    end

    private

    def index_artists_by_name(data)
      artists_by_name = data[:artists].group_by{ |r| r[:name] }.map do |name, artists|
        if artists.length > 1
          puts "More than one artist with same name! #{name}"
          exit
        end
        [name, artists.first]
      end
      Hash[artists_by_name]
    end

    def legacy_sql(command)
      require 'tiny_tds'
      sql = TinyTds::Client.new(host: ENV['LEGACY_SQL_HOST'],
                                username: ENV['LEGACY_SQL_USERNAME'],
                                password: ENV['LEGACY_SQL_PASSWORD'])
      sql.execute(command).to_a
    end

  end

end
