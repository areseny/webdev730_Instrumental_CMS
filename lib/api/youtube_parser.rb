require 'active_support/core_ext/string'

class YoutubeParser
  attr_reader :title, :full_description

  def initialize(title: "", description: "")
    @title = title
    @full_description = description
  end

  SongPattern =
    /^([^|()]+) \| ([^|()]+) \(([^|()]+)\) \s*\|\s*instrumental\s+sesc\s+brasil\s*$/xi

  def song_match
    @song_match ||= SongPattern.match(title)
  end

  InterviewPattern =
    /^([^|()]+) \| \s*entrevista\s*\|\s*instrumental\s+sesc\s+brasil\s*$/xi

  def interview_match
    @interview_match ||= InterviewPattern.match(title)
  end

  VideoChatPattern =
    /^([^|()]+) \| \s*bate-papo\s*\|\s*instrumental\s+sesc\s+brasil\s*$/xi

  def video_chat_match
    @video_chat_match ||= VideoChatPattern.match(title)
  end

  TvShowPattern =
    /^([^|()]+) \|\s*programa\s+instrumental\s+sesc\s+brasil\s*$/xi

  def tv_show_match
    @tv_show_match ||= TvShowPattern.match(title)
  end

  SoundCheckPattern =
    /^([^|()]+) \|\s*programa\s+passagem\s+de\s+som\s*$/xi

  def sound_check_match
    @sound_check_match ||= SoundCheckPattern.match(title)
  end

  LegacyTvShowPattern =
    /^([^|()]+) \|\s*programa\s+instrumental\s+sesc\s+brasil\s+\|\s+memória\s*$/xi

  def legacy_tv_show_match
    @legacy_tv_show_match ||= LegacyTvShowPattern.match(title)
  end

  def title_match
    song_match || interview_match || video_chat_match || tv_show_match ||
      sound_check_match || legacy_tv_show_match
  end

  def title_eligible?
    title_match.present?
  end

  def match_type
    if song_match then :show
    elsif interview_match then :interview
    elsif video_chat_match then :video_chat
    elsif tv_show_match then :tv_show
    elsif sound_check_match then :sound_check
    elsif legacy_tv_show_match then :legacy_tv_show
    else nil
    end
  end

  def artist_name
    @artist_name ||= title_match[1].strip
  end

  def song_title
    @song_title ||= song_match[2].strip if song_match
  end

  def composer_name
    @composer_name ||= song_match[3].strip if song_match
  end

  DescriptionPattern = /\n.+\s*:\s*\n/i

  def description
    @description ||= full_description.split(DescriptionPattern).first
  end

  FactsheetPattern = /^\s*ficha técnica\s*:\s*\n(.+)\n---\n/im

  def factsheet_match
    @factsheet_match ||= FactsheetPattern.match(full_description)
  end

  def factsheet
    @factsheet ||= factsheet_match[1] if factsheet_match
  end

  BandPattern =
    /^\s*formação\s*:\s*\n((?:[^-\n]+-[^-\n]+\n)+)/i

  def band_match
    @band_match ||= BandPattern.match(full_description)
  end

  def band_members
    if band_match
      @band_members ||= begin
        array = band_match[1].split("\n").map do |line|
          name, instruments = line.split('-')
          instruments = instruments.split(/\se\s|,/).map do |instrument|
            instrument.strip.downcase
          end
          [name.strip, instruments]
        end
        array.sort_by(&:first)
      end
    else
      []
    end
  end

  DatePattern =
    /que\s+ocorreu.+dia\s+(\d{2}\/\d{2}\/\d{4})\s*$/i

  def date_match
    @date_match ||= DatePattern.match(full_description)
  end

  def date
    if date_match
      @date ||= Date.strptime(date_match[1], '%d/%m/%Y') rescue nil
    end
  end

  TimecodesPattern = /^(\d{2}):(\d{2})\s*-\s*(.+)$/

  def timecodes
    @timecodes ||= begin
      array = full_description.scan(TimecodesPattern).map do |m, s, desc|
        [m.to_i * 60 + s.to_i, desc]
      end
      array.sort_by(&:first)
    end
  end

  GenrePattern = /^gêneros?:([^\n]+)\n/i

  def genre_match
    @genre_match ||= GenrePattern.match(full_description)
  end

  def genres
    if genre_match
      @genres ||=
        genre_match[1].split(',')
                      .map { |g| g.strip.downcase }
                      .reject { |g| g.blank? }
    else
      @genres ||= []
    end
  end

  def eligible?
    !!(title_eligible? && date && description)
  end

  def self.eligible?(attributes)
    new(title: attributes[:title], description: attributes[:description]).eligible?
  end

end
