module VideoHelper

  def video_player(event)
    if event.playlist?
      ordered_songs = event.songs.ordered.to_a
      playlist = ordered_songs.map{ |s| s.video.youtube_id }
      members = ordered_songs.map{ |s| band_members_as_sentence(s.band_members) }
      video_id = @song.try(:video).try(:youtube_id) || params[:videoId]
      video_id = nil if video_id && !video_id.in?(playlist)
      video_id ||= playlist.first
      data = {
        playlist: playlist,
        members: members,
        video_id: video_id
      }
    elsif event.video
      data = { video_id: event.video.youtube_id }
    else
      data = {}
    end
    content_tag(:div, nil, id: "player", class: "video-player", data: data)
  end

  def band_members_as_sentence(members)
    members.map { |member|
      instruments = member.instruments.map(&:name).to_sentence
      member.artist_name + " - " + instruments
    }.join("; ")
  end

end
