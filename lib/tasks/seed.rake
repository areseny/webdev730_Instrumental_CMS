namespace :db do

  task :seed => :environment do
    data = YAML.load_file(File.expand_path("db/legacy/seeds.yml"))
    Artist.transaction do
      artists = data[:artists].sort_by{ |r| r[:name] }
      artists.each do |row|
        artist = create_artist(row)
        create_images(artist, row)
        row[:shows].each { |s| create_show(artist, s) }
        row[:legacy_shows].each { |s| create_show(artist, s, true) }
        row[:interviews].each { |e| create_interview(artist, e) }
        row[:video_chats].each { |e| create_video_chat(artist, e) }
        row[:tv_shows].each { |e| create_tv_show(artist, e) }
        row[:sound_checks].each { |e| create_sound_check(artist, e) }
        row[:legacy_tv_shows].each { |e| create_legacy_tv_show(artist, e) }
      end
      tomze = Artist.find_by_slug!('tom-ze')
      Feature.create!(featurable: tomze.tv_shows.first, enabled: true)
    end
  end

  private

  def create_images(artist, row)
    if row[:banner]
      artist[:banner] = row[:banner]
      artist[:banner_width] = row[:banner_width]
      artist[:banner_height] = row[:banner_height]
    end
    if row[:thumbnail]
      artist[:thumbnail] = row[:thumbnail]
    end
    (row[:gallery] || []).each do |image|
      artist.gallery.create! do |img|
        img[:image] = image[:image]
        img[:width] = image[:width]
        img[:height] = image[:height]
      end
    end
    artist.save!
  end

  def create_artist(row)
    attrs = row.slice(:name, :description, :facebook_page, :twitter_widget_id, :legacy_ids)
    Artist.create!(attrs) do |artist|
      artist.sort_name = artist.name.gsub(/^(a|as|o|os|à|\d+)?\s/i, "").camelize
      artist.slug = artist.name.parameterize
      artist.first_letter = I18n.transliterate(artist.sort_name)[0].downcase.gsub(/[^a-z]/, "~")
    end
  end

  def create_show(artist, row, legacy = false)
    existing = Event.find_by_date(row[:date]).try(:artist)
    if existing && existing != artist
      puts "Conflito de datas: #{artist.name} em #{row[:date]} (#{existing.name})"
      nil
    elsif row[:songs].nil? || row[:songs].empty?
      puts "Show sem nenhuma música: #{artist.name} em #{row[:date]}"
      nil
    elsif row[:songs].all?{ |s| s[:video].nil? }
      puts "Show sem nenhum vídeo: #{artist.name} em #{row[:date]}"
      nil
    else
      relation = legacy ? :legacy_shows : :shows
      data = row.slice(:legacy_id, :date, :description)
      artist.send(relation).create!(data) do |show|
        show.slug = event_slug(show)
        row[:songs].each do |s|
          video = build_video(s[:video])
          genres = map_genres(s[:genres])
          band_members = map_band_members(s[:band_members])
          song = Song.new(s.slice(:title, :composer)) do |song|
            song.video = video
            song.genres << genres
            song.band_members << band_members
          end
          show.songs << song
        end
      end
    end
  end

  def create_interview(artist, row)
    existing = Event.find_by_date(row[:date]).try(:artist)
    if existing && existing != artist
      puts "Conflito de datas: #{artist.name} em #{row[:date]} (#{existing.name})"
      nil
    elsif row[:video].nil?
      puts "Entrevista sem vídeo: #{artist.name} em #{row[:date]}"
      nil
    else
      data = row.slice(:legacy_id, :date, :description)
      artist.interviews.create!(data) do |event|
        event.slug = event_slug(event)
        event.video = build_video(row[:video])
      end
    end
  end

  def create_video_chat(artist, row)
    existing = Event.find_by_date(row[:date]).try(:artist)
    if existing && existing != artist
      puts "Conflito de datas: #{artist.name} em #{row[:date]} (#{existing.name})"
      nil
    elsif row[:video].nil?
      puts "Bate-papo sem vídeo: #{artist.name} em #{row[:date]}"
      nil
    else
      data = row.slice(:legacy_id, :date, :description)
      artist.video_chats.create!(data) do |event|
        event.slug = event_slug(event)
        event.video = build_video(row[:video])
      end
    end
  end

  def create_tv_show(artist, row)
    existing = Event.find_by_date(row[:date]).try(:artist)
    if existing && existing != artist
      puts "Conflito de datas: #{artist.name} em #{row[:date]} (#{existing.name})"
      nil
    elsif row[:video].nil?
      puts "Programa instrumental sem vídeo: #{artist.name} em #{row[:date]}"
      nil
    else
      data = row.slice(:legacy_id, :date, :description, :factsheet)
      artist.tv_shows.create!(data) do |event|
        event.slug = event_slug(event)
        event.video = build_video(row[:video])
      end
    end
  end

  def create_sound_check(artist, row)
    existing = Event.find_by_date(row[:date]).try(:artist)
    if existing && existing != artist
      puts "Conflito de datas: #{artist.name} em #{row[:date]} (#{existing.name})"
      nil
    elsif row[:video].nil?
      puts "Programa passagem de som sem vídeo: #{artist.name} em #{row[:date]}"
      nil
    else
      data = row.slice(:legacy_id, :date, :description, :factsheet)
      artist.sound_checks.create!(data) do |event|
        event.slug = event_slug(event)
        event.video = build_video(row[:video])
      end
    end
  end

  def create_legacy_tv_show(artist, row)
    existing = Event.find_by_date(row[:date]).try(:artist)
    if existing && existing != artist
      puts "Conflito de datas: #{artist.name} em #{row[:date]} (#{existing.name})"
      nil
    elsif row[:video].nil?
      puts "Programa memória sem vídeo: #{artist.name} em #{row[:date]}"
      nil
    else
      data = row.slice(:legacy_id, :date, :description, :factsheet)
      artist.legacy_tv_shows.create!(data) do |event|
        event.slug = event_slug(event)
        event.video = build_video(row[:video])
      end
    end
  end

  def build_video(row)
    timecodes = row.delete(:timecodes) || []
    row[:youtube_id] = row.delete(:video_id)
    row[:comments] = row.delete(:comment_count)
    row[:views] = row.delete(:view_count)
    row[:likes] = row.delete(:like_count)
    row[:dislikes] = row.delete(:dislike_count)
    thumbnails = row.delete(:thumbnails)
    row[:large_thumbnail] = thumbnails['maxres'] || thumbnails['high'] || thumbnails['medium']
    row[:small_thumbnail] = thumbnails["default"]
    Video.new(row) do |video|
      timecodes.each do |seconds, description|
        video.timecodes << Timecode.new(seconds: seconds, description: description)
      end
    end
  end

  def map_band_members(data)
    data.map do |artist_name, instruments|
      BandMember.new(artist_name: artist_name, instruments: map_instruments(instruments))
    end
  end

  def event_slug(event)
    date = I18n.l(event.date, format: "%d-%B-%Y")
    I18n.t("slugs.#{event.class.name.underscore}") + "-em-" + date.parameterize
  end

  def map_genres(data)
    data.map { |name| Genre.where(name: name).first_or_create! }
  end

  def map_instruments(data)
    data.map { |name| Instrument.where(name: name).first_or_create! }
  end

end
