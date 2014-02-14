require 'dotenv/tasks'

namespace :videos do

  # Sync video information with YouTube
  task :sync do
    require 'dotenv'
    Dotenv.load
    Rake::Task["environment"].execute
    Video.transaction do
      parsed_videos.each do |parsed_video|
        video = Video.where(youtube_id: parsed_video[:video_id]).first_or_initialize
        if video.new_record?
          parser = YoutubeParser.new(title: parsed_video[:title],
                                     description: parsed_video[:description])
          event_type = parser.match_type.to_s.classify
          event_type = "LegacyShow" if event_type == "Show" && parser.date.year <= 2004
          artist = Artist.find_by_name(parser.artist_name)
          if artist.nil?
            logger.info "#{video_url(parsed_video)} Artista não encontrado: "\
                        "#{parser.artist_name}"
            next
          else
            event = Event.where(date: parser.date, type: event_type).first
            if event && event.artist_id != artist.id
              logger.info "#{video_url(parsed_video)}  Conflito com evento existente: "\
                          "#{event.date} (#{event.artist.name})"
              next
            end
          end
        end

        thumbnails = parsed_video[:thumbnails]
        video.attributes = {
          auth_user_id: youtube.user_id,
          title: parsed_video[:title],
          description: parsed_video[:description],
          tags: parsed_video[:tags],
          comments: parsed_video[:comment_count],
          views: parsed_video[:view_count],
          likes: parsed_video[:like_count],
          dislikes: parsed_video[:dislike_count],
          large_thumbnail: thumbnails['maxres'] || thumbnails['high'] || thumbnails['medium'],
          small_thumbnail: thumbnails['default'],
        }
        video.timecodes.clear
        video.timecodes = (parsed_video[:timecodes] || []).map do |seconds, description|
          Timecode.new(seconds: seconds, description: description)
        end
        if video.new_record?
          event = Event.where(type: event_type, date: parser.date)
                       .first_or_create!(artist: artist,
                                         description: parser.description,
                                         factsheet: parser.factsheet,
                                         slug: generate_event_slug(parser.date, event_type))
          if event_type == "Show" || event_type == "LegacyShow"
            song = Song.create!(playlistable: event,
                                title: parser.song_title,
                                composer: parser.composer_name)
            song.genres << (parsed_video[:genres] || []).map do |genre_name|
              Genre.where(name: genre_name).first_or_create!
            end
            (parsed_video[:band_members] || []).each do |name, instrument_names|
              instruments = instrument_names.map do |instrument_name|
                Instrument.where(name: instrument_name).first_or_create!
              end
              BandMember.create!(song: song, artist_name: name, instruments: instruments)
            end
            video.viewable = song
          else
            video.viewable = event
          end
          event.update_attributes!(description: parser.description,
                                   factsheet: parser.factsheet,
                                   visible: true)
        end
        video.save!
      end
    end
  end

  private

  def youtube
    @youtube ||= AuthProvider.find_by_key!("youtube")
  end

  def client
    @client ||= YoutubeClient.new(youtube.token)
  end

  def parsed_videos
    return to_enum(:parsed_videos) unless block_given?
    eligible_uploads.each_slice(50) do |uploads|
      videos_by_id = uploads.index_by { |u| u[:video_id] }
      ids = videos_by_id.keys
      client.videos(ids).each do |video|
        id = video[:video_id]
        yield video.merge(videos_by_id[id])
      end
    end
  end

  def eligible_uploads
    return to_enum(:eligible_uploads) unless block_given?
    client.uploads.each do |upload|
      if Video.exists?(youtube_id: upload[:video_id]) || YoutubeParser.eligible?(upload)
        yield upload
      end
    end
  end

  def generate_event_slug(date, type)
    date_slug = I18n.l(date, format: "%d-%B-%Y")
    I18n.t("slugs.#{type.underscore}") + "-em-" + date_slug.parameterize
  end

  def logger
    @logger ||= Rails.env.development? ? Logger.new(STDOUT) : Rails.logger
  end

  def video_url(video)
    "http://www.youtube.com/watch?v=#{video[:video_id]}"
  end

end
