require 'faraday_middleware'

class YoutubeClient
  attr_reader :refresh_token

  ResultsPerPage = 50

  def initialize(refresh_token)
    @refresh_token = refresh_token
  end

  def uploads_playlist_id
    @uploads_playlist_id ||= (
      response = api.get("channels", mine: true, part: 'contentDetails')
      response.body.items[0].contentDetails.relatedPlaylists.uploads
    )
  end

  def uploads
    return to_enum(:uploads) unless block_given?
    pageToken = nil
    begin
      response = api.get("playlistItems",
                         playlistId: uploads_playlist_id,
                         part: 'snippet',
                         maxResults: ResultsPerPage,
                         pageToken: pageToken).body
      pageToken = response.nextPageToken
      response.items.each do |i|
        yield({
          video_id: i.snippet.resourceId.videoId,
          title: i.snippet.title,
          description: i.snippet.description
        })
      end
    end while pageToken
  end

  def videos(ids)
    raise "Too many videos" if ids.length > 50
    return to_enum(:videos, ids) { ids.length } unless block_given?
    response = api.get("videos", id: ids.join(","),
                       part: 'snippet,statistics').body
    response.items.each do |i|
      yield({
        video_id: i.id,
        title: i.snippet.title,
        description: i.snippet.description,
        thumbnails: Hash[i.snippet.thumbnails.map { |k, v| [k, v.url] }],
        tags: i.snippet.tags || [],
        view_count: i.statistics.viewCount,
        like_count: i.statistics.likeCount,
        dislike_count: i.statistics.dislikeCount,
        comment_count: i.statistics.commentCount
      })
    end
  end

  private

  def access_token
    @access_token ||= (
      response = accounts.post(
        "o/oauth2/token",
        grant_type: 'refresh_token',
        refresh_token: refresh_token,
        client_id: ENV['YOUTUBE_KEY'],
        client_secret: ENV['YOUTUBE_SECRET'])
      response.body["access_token"]
    )
  end

  def accounts
    @accounts ||= connection("https://accounts.google.com")
  end

  def api
    @api ||= connection("https://www.googleapis.com/youtube/v3") do |f|
      f.headers[:authorization] = "Bearer #{access_token}"
    end
  end

  def connection(url)
    Faraday.new(url) do |f|
      f.headers = {
        accept: 'application/json',
        user_agent: 'Instrumental SESC Brasil'
      }
      yield(f) if block_given?
      f.request  :url_encoded
      f.response :mashify
      f.response :json
      f.response :raise_error
      f.adapter  Faraday.default_adapter
    end
  end

end
