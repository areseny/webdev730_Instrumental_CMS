namespace :db do

  namespace :legacy do

    # Generates db/legacy/dump.yml file, containing
    # the data from the original legacy database
    task :dump do
      require 'dotenv'
      Dotenv.load
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
      update_seeds results
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
      update_seeds data
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

    # applies the corrections from db/legacy/corrections.yml
    # into db/legacy/merged.yml,
    # generating the file db/legacy/corrected.yml
    task :correct do
      data = YAML.load_file(File.expand_path("db/legacy/merged.yml"))
      artists_by_name = index_artists_by_name(data)
      artists_by_legacy_id = index_artists_by_legacy_id(data)
      shows_by_legacy_id = index_shows_by_legacy_id(data)
      interviews_by_legacy_id = index_interviews_by_legacy_id(data)
      video_chats_by_legacy_id = index_video_chats_by_legacy_id(data)
      # Fix artists with empty or "xxxxx" descriptions
      data[:artists].each do |art|
        if (art[:description] || "").strip =~ /^x*$/ && art[:shows]
          art[:description] = art[:shows].first[:description]
        end
      end
      corrections = YAML.load_file(File.expand_path("db/legacy/corrections.yml"))
      corrections[:remove_artists_by_legacy_id].each do |legacy_id|
        data[:artists].delete artists_by_legacy_id[legacy_id]
        artists_by_legacy_id.delete(legacy_id)
      end
      corrections[:date_changes][:shows].each do |legacy_id, date|
        shows_by_legacy_id[legacy_id][:date]= date
      end
      corrections[:date_changes][:interviews].each do |legacy_id, date|
        interviews_by_legacy_id[legacy_id][:date]= date
      end
      corrections[:date_changes][:video_chats].each do |legacy_id, date|
        video_chats_by_legacy_id[legacy_id][:date]= date
      end
      corrections[:name_changes].each do |old_name, new_name|
        artist = artists_by_name.delete(old_name)
        artist[:name] = new_name
        if existing_artist = artists_by_name[new_name]
          data[:artists].delete artist
          existing_artist[:shows] += (artist[:shows] || [])
          existing_artist[:interviews] += (artist[:interviews] || [])
          existing_artist[:video_chats] += (artist[:video_chats] || [])
          existing_artist[:legacy_ids] += (artist[:legacy_ids] || [])
          existing_artist[:facebook_page] ||= artist[:facebook_page]
          existing_artist[:twitter_widget_id] ||= artist[:twitter_widget_id]
          # Merge images on folders:
          Dir["tmp/legacy/images/#{old_name}/*.jpg"].each_with_index do |file, i|
            FileUtils.mv file, "tmp/legacy/images/#{new_name}/merged_#{i}"
          end
        else
          artists_by_name[new_name] = artist
          # Rename folder
          if Dir.exists?("tmp/legacy/images/#{old_name}")
            FileUtils.mv "tmp/legacy/images/#{old_name}", "tmp/legacy/images/tmp-folder"
            FileUtils.mv "tmp/legacy/images/tmp-folder", "tmp/legacy/images/#{new_name}"
          end
        end
      end
      corrections[:additions].each do |artist|
        data[:artists] << artist
      end
      File.open("db/legacy/corrected.yml", 'w') { |f| f.write data.to_yaml }
      update_seeds data
    end

    # Loads data from YouTube video uploads and sync with
    # data contained in db/legacy/corrected.yml,
    # generating db/legacy/synced.yml
    task :sync => :environment do
      data = YAML.load_file(File.expand_path("db/legacy/corrected.yml"))
      artists_by_name = index_artists_by_name(data)
      youtube = AuthProvider.find_by_key!("youtube")
      user_id = youtube.user_id
      token = youtube.token
      client = YoutubeClient.new(token)

      # Normalize collections first
      collections = [
        :shows, :interviews, :video_chats, :tv_shows,
        :sound_checks, :legacy_tv_shows, :legacy_shows
      ]
      data[:artists].each do |artist|
        collections.each do |collection|
          artist[collection] ||= []
        end
      end

      uploads = client.uploads
      uploads.each do |video|
        parser = YoutubeParser.new(title: video[:title], description: video[:description])
        if parser.eligible?
          artist = artists_by_name[parser.artist_name]
          if artist
            collection = parser.match_type.to_s.pluralize.to_sym
            collection = :legacy_shows if collection == :shows && parser.date.year <= 2004
            event = artist[collection].detect { |e| e[:date] == parser.date.to_s }
            if event.nil?
              event = { description: parser.description, date: parser.date.to_s }
              artist[collection] << event
            end
            if event[:video]
              puts "\tVídeo duplicado encontrado: #{youtube_link(video)}"
            else
              event[:factsheet] = parser.factsheet if parser.factsheet
              video[:timecodes] = parser.timecodes if parser.timecodes.any?
              artist[:description] = parser.description if artist[:description].nil?
              if collection == :shows || collection == :legacy_shows
                song = {
                  title: parser.song_title,
                  composer: parser.composer_name,
                  band_members: parser.band_members,
                  genres: parser.genres,
                  video: video
                }
                event[:songs] ||= []
                event[:songs] << song
              else
                event[:video] = video
              end
            end
          else
            puts "\tArtista não encontrado (#{parser.artist_name}): http://www.youtube.com/watch?v=#{video[:video_id]}\n"
          end
        end
      end
      File.open('db/legacy/synced.yml', 'w') { |f| f.write(data.to_yaml) }
      update_seeds data
    end

    # Uploads artist images in the Dropbox folder to Amazon S3,
    # and updates the references in db/legacy/seeds.yml
    task :upload_images do
      require 'dotenv'
      Dotenv.load
      Rake::Task["environment"].execute
      data = YAML.load_file(File.expand_path("db/legacy/seeds.yml"))
      artists_by_slug = index_artists_by_slug(data)
      path = File.expand_path("~/Dropbox/Instrumental/IMAGENS")
      directories = Dir.glob("#{path}/*").select{ |d| File.directory?(d) }
      directories.each do |directory|
        artist_name = File.basename(directory).to_s.strip.force_encoding("UTF-8")
        slug = artist_name.parameterize
        artist = artists_by_slug[slug]
        if artist.nil?
          puts "Artist not found: #{artist_name}"
        else
          Dir["#{path}/#{artist_name}/*.jpg"].each do |file|
            if File.basename(file) == "thumbnail.jpg"
              model = OpenStruct.new(slug: slug)
              uploader = ThumbnailUploader.new(model)
              uploader.cache!(File.open(file))
              if artist[:thumbnail] != uploader.filename
                uploader.store!
                puts "Uploaded: #{uploader.url}"
                artist[:thumbnail] = uploader.filename
              end
            elsif File.basename(file) == "banner.jpg"
              model = OpenStruct.new(slug: slug)
              uploader = BannerUploader.new(model)
              uploader.cache!(File.open(file))
              if artist[:banner] != uploader.filename
                uploader.store!
                artist[:banner] = uploader.filename
                artist[:banner_width] = model.banner_width
                artist[:banner_height] = model.banner_height
                puts "Uploaded: #{uploader.url}"
              end
            else
              model = OpenStruct.new(artist: OpenStruct.new(slug: slug))
              uploader = GalleryUploader.new(model)
              uploader.cache!(File.open(file))
              artist[:gallery] ||= []
              if artist[:gallery].detect{ |i| i[:image] == uploader.filename }.nil?
                gallery_model = OpenStruct.new(artist: model)
                uploader.store!
                artist[:gallery] << {
                  image: uploader.filename,
                  width: model.width,
                  height: model.height,
                }
                puts "Uploaded: #{uploader.url}"
              end
            end
          end
        end
      end
      update_seeds(data)
    end

    # Uses Youtube API to download remaining video data
    # and updates db/legacy/seeds.yml
    task :download_video_data do
      require 'dotenv'
      Dotenv.load
      Rake::Task["environment"].execute
      youtube = AuthProvider.find_by_key!("youtube")
      user_id = youtube.user_id
      token = youtube.token
      client = YoutubeClient.new(token)
      data = YAML.load_file(File.expand_path("db/legacy/seeds.yml"))
      videos_by_id = index_videos_by_video_id(data)
      videos_by_id.keys.in_groups_of(50, false) do |ids|
        client.videos(ids).each do |downloaded_video|
          downloaded_video.merge!(auth_user_id: user_id)
          id = downloaded_video[:video_id]
          videos_by_id[id].merge!(downloaded_video)
          puts "Updated video: #{id}"
        end
      end
      update_seeds(data)
    end

    # Try to associate artists with instruments in db/legacy/seeds.yml
    # by matching the name of the artist with band members
    task :set_artist_instruments do
      data = YAML.load_file(File.expand_path("db/legacy/seeds.yml"))
      artists_by_name = index_artists_by_name(data)
      data[:artists].each do |artist|
        (artist[:shows] + artist[:legacy_shows]).each do |show|
          (show[:songs] || []).each do |song|
            (song[:band_members] || []).each do |artist_name, instruments|
              if existing = artists_by_name[artist_name]
                existing[:instruments] ||= []
                existing[:instruments] += instruments
                existing[:instruments] = existing[:instruments].uniq
              end
            end
          end
        end
      end
      update_seeds(data)
    end

    # Downloads mp3 files for all videos in db/legacy/seeds.yml
    task :download_mp3 => :environment do
      Rake::Task["environment"].execute
      data = YAML.load_file(File.expand_path("db/legacy/seeds.yml"))
      all_ids = []
      data[:artists].each do |artist|
        all_shows = artist[:shows] + artist[:legacy_shows]
        all_shows.each do |show|
          (show[:songs] || []).each do |song|
            all_ids << song[:video][:video_id]
          end
        end
      end
      all_ids.in_groups_of(8) do |ids|
        threads = ids.map do |id|
          Thread.new do
            url = "http://www.youtube.com/watch?v=#{id}"
            if !File.exists?("tmp/mp3/#{id}.mp3")
              system "mkdir -p tmp/mp3 && cd tmp/mp3 && "\
                "youtube-dl -x -f flv --id --audio-format mp3 --no-progress --quiet #{url}"
            end
            puts url
          end
        end
        threads.each &:join
      end
    end

    # Generates a CSV file from the contents in
    # db/legacy/synced.yml, for checking purposes
    task :csv_dump do
      data = YAML.load_file(File.expand_path("db/legacy/synced.yml"))
      puts [
        "Artista", "Data", "Evento", "Vídeo", "Descrição", "Ficha Técnica",
        "Título", "Compositor", "Gêneros", "Formação"
      ].join("\t")
      data[:artists].each do |artist|
        puts [artist[:name], nil, nil, nil, truncated_text(artist[:description])].join("\t")
        artist[:shows].each { |show| dump_csv_show show, "Show" }
        artist[:legacy_shows].each { |show| dump_csv_show show, "Show (Memória)" }
        artist[:interviews].each { |event| dump_csv_event event, "Entrevista" }
        artist[:video_chats].each { |event| dump_csv_event event, "Bate-Papo" }
        artist[:tv_shows].each { |event| dump_csv_event event, "Programa Instrumental" }
        artist[:sound_checks].each { |event| dump_csv_event event, "Programa Passagem de Som" }
        artist[:legacy_tv_shows].each { |event| dump_csv_event event, "Programa Memória" }
      end
    end

    private

    def update_seeds(data)
      File.open("db/legacy/seeds.yml", 'w') { |f| f.write(data.to_yaml) }
    end

    def dump_csv_show(show, type)
      puts [nil, show[:date], type, nil, truncated_text(show[:description])].join("\t")
      if (show[:songs] || []).any?
        show[:songs].each do |song|
          puts [
            nil, nil, "Música",
            youtube_link(song[:video]),
            nil, nil,
            song[:title], song[:composer],
            song[:genres].to_sentence,
            dump_csv_band_members(song)
          ].join("\t")
        end
      else
        puts [ nil, nil, "Nenhuma música nesse show" ].join("\t")
      end
    end

    def dump_csv_event(event, type)
      puts [
        nil, event[:date], type, youtube_link(event[:video]),
        truncated_text(event[:description]),
        truncated_text(event[:factsheet]),
      ].join("\t")
    end

    def truncated_text(text)
      text_helper.truncate((text || "").gsub(/\t/, " "), length: 50)
    end

    def text_helper
      @text_helper ||= Object.new.extend(ActionView::Helpers::TextHelper)
    end

    def dump_csv_band_members(song)
      members = song[:band_members] || {}
      members.map{ |name, inst| "#{name}: #{inst.to_sentence}" }.join("; ")
    end

    def youtube_link(video)
      if video
        "http://www.youtube.com/watch?v=#{video[:video_id]}"
      else
        "Vídeo não cadastrado"
      end
    end

    def index_videos_by_video_id(data)
      indexed = {}
      viewable = [ :interviews, :tv_shows, :video_chats, :sound_checks, :legacy_tv_shows ]
      playlists = [ :shows, :legacy_shows ]
      data[:artists].each do |artist|
        viewable.each do |collection|
          artist[collection].each do |item|
            if video = item[:video]
              indexed[video[:video_id]] = video
            end
          end
        end
        playlists.each do |collection|
          artist[collection].each do |item|
            (item[:songs] || []).each do |song|
              if video = song[:video]
                indexed[video[:video_id]] = video
              end
            end
          end
        end
      end
      indexed
    end

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

    def index_artists_by_slug(data)
      indexed = data[:artists].group_by{ |r| r[:name].parameterize }
      indexed = indexed.map do |slug, artists|
        if artists.length > 1
          puts "More than one artist with same slug! #{slug}"
          exit
        end
        [slug, artists.first]
      end
      Hash[indexed]
    end

    def index_artists_by_legacy_id(data)
      results = {}
      data[:artists].each do |art|
        art[:legacy_ids].each { |id| results[id] = art }
      end
      results
    end

    def index_shows_by_legacy_id(data)
      all_shows = data[:artists].map { |a| a[:shows] || [] }.flatten
      results = all_shows.group_by{ |r| r[:legacy_id] }.map do |legacy_id, shows|
        if shows.length > 1
          puts "More than one show with same legacy_id! #{legacy_id}"
          exit
        end
        [legacy_id, shows.first]
      end
      Hash[results]
    end

    def index_interviews_by_legacy_id(data)
      all_interviews = data[:artists].map { |a| a[:interviews] || [] }.flatten
      results = all_interviews.group_by{ |r| r[:legacy_id] }.map do |legacy_id, interviews|
        if interviews.length > 1
          puts "More than one interview with same legacy_id! #{legacy_id}"
          exit
        end
        [legacy_id, interviews.first]
      end
      Hash[results]
    end

    def index_video_chats_by_legacy_id(data)
      all_video_chats = data[:artists].map { |a| a[:video_chats] || [] }.flatten
      results = all_video_chats.group_by{ |r| r[:legacy_id] }.map do |legacy_id, video_chats|
        if video_chats.length > 1
          puts "More than one video_chat with same legacy_id! #{legacy_id}"
          exit
        end
        [legacy_id, video_chats.first]
      end
      Hash[results]
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
