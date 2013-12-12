namespace :db do
  task :fix_seeds => :environment do
    data = YAML.load_file(File.expand_path("db/legacy/seeds.yml"))
    instruments = {}
    genres = {}
    artists = {}
    gallery_images = {}
    events = {}
    songs = {}
    band_members = {}
    videos = {}
    timecodes = {}
    data[:artists].each do |row|
      artist = row.slice(:name, :description, :facebook_page, :twitter_widget_id,
                         :legacy_ids, :banner, :banner_width, :banner_height, :thumbnail)
      artist.stringify_keys!
      slug = artist["name"].parameterize
      sort_name = artist["name"].gsub(/^(a|as|o|os|à|\d+)?\s/i, "").camelize
      first_letter = I18n.transliterate(sort_name)[0].downcase.gsub(/[^a-z]/, "~")
      artist["slug"] = slug
      artist["sort_name"] = sort_name
      artist["first_letter"] = first_letter
      (row[:gallery] || []).each do |img|
        img.stringify_keys!
        img["artist"] = slug
        gallery_images[img['image']] = img
      end
      artist["instruments"] = []
      (row[:instruments] || []).each do |instrument|
        instruments[instrument] ||= { "name" => instrument }
        artist["instruments"] << instrument
      end
      artists[slug] = artist
      event_types = {
        interviews: "Interview",
        video_chats: "VideoChat",
        tv_shows: "TvShow",
        sound_checks: "SoundCheck",
        legacy_tv_shows: "LegacyTvShow",
      }
      event_types.each do |key, type|
        (row[key] || []).each do |row|
          event = row.slice(:legacy_id, :date, :description, :factsheet)
          event.stringify_keys!
          event["date"] = Date.parse(event["date"])
          event["artist"] = artist["slug"]
          event["type"] = type
          slug = event["slug"] = generate_event_slug(event["date"], type)
          if existing = events[slug]
            puts "Conflito de datas: "
            puts "\t#{existing['artist']}: #{existing['slug']}"
            puts "\t#{event['artist']}: #{event['slug']}"
          else
            if video = parse_video(row[:video], "#{slug} (Event)")
              videos[video["youtube_id"]] = video
              parse_timecodes(row[:video][:timecodes], video["youtube_id"]).each do |tc|
                timecodes["#{video['youtube_id']}_#{tc['seconds']}"] = tc
              end
              event["visible"] = true
            else
              event["visible"] = false
            end
            events[slug] = event
          end
        end
      end
      playlist_types = {
        shows: "Show",
        legacy_shows: "LegacyShow",
      }
      playlist_types.each do |key, type|
        (row[key] || []).each do |row|
          event = row.slice(:legacy_id, :date, :description, :factsheet)
          event.stringify_keys!
          event["date"] = Date.parse(event["date"])
          event["artist"] = artist["slug"]
          event["type"] = type
          slug = event["slug"] = generate_event_slug(event["date"], type)
          if existing = events[slug]
            puts "Conflito de datas: "
            puts "\t#{existing['artist']}: #{existing['slug']}"
            puts "\t#{event['artist']}: #{event['slug']}"
          else
            event["visible"] = false
            (row[:songs] || []).each_with_index do |row, position|
              song = row.slice(:title, :composer)
              song.stringify_keys!
              song_key = event['slug'] + "-song-#{position}"
              song["playlistable"] = "#{event['slug']} (Event)"
              song["position"] = position + 1
              if video = parse_video(row[:video], "#{song_key} (Song)")
                videos[video["youtube_id"]] = video
                parse_timecodes(row[:video][:timecodes], video["youtube_id"]).each do |tc|
                  timecodes["#{video['youtube_id']}_#{tc['seconds']}"] = tc
                end
                event["visible"] = true
              end
              song["genres"] = []
              (row[:genres] || []).each do |genre|
                genres[genre] ||= { "name" => genre }
                song["genres"] << genre
              end
              (row[:band_members] || []).each do |artist_name, inst|
                band_member_key = song_key + "-#{artist_name}"
                band_member = { "artist_name" => artist_name, "song" => song_key }
                band_member["instruments"] = []
                inst.each do |instrument|
                  instruments[instrument] ||= { "name" => instrument }
                  band_member["instruments"] << instrument
                end
                band_members[band_member_key] = band_member
              end
              songs[song_key] = song
            end
            events[slug] = event
          end
        end
      end
    end
    File.open("db/seeds/instruments.yml", 'w') { |f| f.write(instruments.to_yaml) }
    File.open("db/seeds/genres.yml", 'w') { |f| f.write(genres.to_yaml) }
    File.open("db/seeds/artists.yml", 'w') { |f| f.write(artists.to_yaml) }
    File.open("db/seeds/gallery_images.yml", 'w') { |f| f.write(gallery_images.to_yaml) }
    File.open("db/seeds/events.yml", 'w') { |f| f.write(events.to_yaml) }
    File.open("db/seeds/songs.yml", 'w') { |f| f.write(songs.to_yaml) }
    File.open("db/seeds/band_members.yml", 'w') { |f| f.write(band_members.to_yaml) }
    File.open("db/seeds/videos.yml", 'w') { |f| f.write(videos.to_yaml) }
    File.open("db/seeds/timecodes.yml", 'w') { |f| f.write(timecodes.to_yaml) }
  end

  private

  def generate_event_slug(date, type)
    date_slug = I18n.l(date, format: "%d-%B-%Y")
    I18n.t("slugs.#{type.underscore}") + "-em-" + date_slug.parameterize
  end

  def parse_video(video, viewable)
    if video
      thumbnails = video[:thumbnails]
      fixture = {
        "youtube_id" => video[:video_id],
        "auth_user_id" => video[:auth_user_id],
        "title" => video[:title],
        "description" => video[:description],
        "tags" => video[:tags],
        "comments" => video[:comment_count].to_i,
        "views" => video[:view_count].to_i,
        "likes" => video[:like_count].to_i,
        "dislikes" => video[:dislike_count].to_i,
        "viewable" => viewable,
        "large_thumbnail" => thumbnails['maxres'] || thumbnails['high'] || thumbnails['medium'],
        "small_thumbnail" => thumbnails['default']
      }
    end
  end

  def parse_timecodes(timecodes, youtube_id)
    (timecodes || []).map do |seconds, description|
      {
        "video" => youtube_id,
        "seconds" => seconds,
        "description" => description
      }
    end
  end
end
