root = exports ? this

createPlayer = ->
  videoId = $.url().param("video_id") || $("#player").data("videoId")
  origin = $('meta[name=youtube-origin]').attr("content")
  autoplay = $('meta[name=youtube-autoplay]').attr("content")
  if videoId
    root.player = new YT.Player "player",
      width: 640
      height: 380
      videoId: videoId
      playerVars:
        autoplay: autoplay
        autohide: 1
        rel: 0
        showinfo: 1
        enablejsapi: 1
        origin: origin
      events:
        onStateChange: playerStateChange

root.onYouTubeIframeAPIReady = -> createPlayer()

jQuery ->
  if $("#player").length > 0
    $.getScript "//youtube.com/iframe_api"

$(document).on "click", "[data-skip-to]", ->
  seconds = $(this).data("skipTo")
  if root.player && seconds
    root.player.seekTo seconds
  false

selectItem = (videoId) ->
  $(".video-nav li").removeClass("selected")
  $("[data-video-id='#{videoId}']").closest("li").addClass("selected")
  playlist = $("#player").data("playlist")
  members = $("#player").data("members")
  if playlist.length > 0 && members.length > 0
    index = playlist.indexOf(videoId)
    $(".band-members p").html members[index]

$(document).on "click", "[data-video-id]", ->
  videoId = $(this).data("videoId")
  selectItem videoId
  root.player.loadVideoById videoId: videoId
  false

playerStateChange = (e) ->
  if e.data == YT.PlayerState.PLAYING
    videoId = root.player.getVideoData().video_id
    selectItem videoId
  else if e.data == YT.PlayerState.ENDED
    videoId = root.player.getVideoData().video_id
    playlist = $("#player").data("playlist")
    currentItem = playlist.indexOf(videoId)
    nextVideoId = playlist[currentItem + 1]
    if nextVideoId
      root.player.loadVideoById videoId: nextVideoId
