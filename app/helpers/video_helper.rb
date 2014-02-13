module VideoHelper

  def video_player(event)
    if event.playlist?
      playlist = event.songs.map{ |s| s.video.youtube_id }
      members = event.songs.map{ |s| band_members_as_sentence(s.band_members) }
      video_id = params[:videoId].in?(playlist) ? params[:videoId] : playlist.last
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
