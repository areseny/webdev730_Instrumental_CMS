jQuery(function($) {

  var addSongToPlaylist = function(song_id, item) {
    cookieStr = $.cookie('instrumental-playlist');
    var added = false;
    if(!cookieStr) {
      cookieStr = '|' + song_id + '|';
      added = true;
    }
    else if(cookieStr.indexOf('|' + song_id + '|') == -1) {
      cookieStr = cookieStr + song_id + '|';
      added = true;
    }
    if(added) {
      $.cookie('instrumental-playlist', cookieStr);
      $(".clear-playlist").show();
      $(".playlist-list").append(JSON.parse(item));
    }
  };

  var removeSongFromPlaylist = function(song_id) {
    cookieStr = $.cookie('instrumental-playlist');
    if(cookieStr) {
      cookieStr = cookieStr.replace('|' + song_id + '|', '|');
      $.cookie('instrumental-playlist', cookieStr);
    }
  };

  $(document).on("click", ".playlist-add", function() {
    link = $(this);
    song_id = link.data("songId");
    item = link.data("item");
    addSongToPlaylist(song_id, item);
    return false;
  });

  $(document).on("click", ".playlist-delete", function() {
    link = $(this);
    song_id = link.data("id");
    removeSongFromPlaylist(song_id);
    link.closest("li").remove();
    return false;
  });

  $(document).on("click", ".clear-playlist", function() {
    $(".playlist-list li").remove();
    $.removeCookie('instrumental-playlist');
    $(".clear-playlist").hide();
  });

  var playerStateChange = function(e) {
    if(e.data == YT.PlayerState.PLAYING) {
      videoId = window.playlistPlayer.getVideoData().video_id;
      $(".playlist-list li").removeClass("selected");
      $(".playlist-list li:has(a[data-video=" + videoId + "])").addClass("selected");
    }
    else if(e.data == YT.PlayerState.ENDED) {
      videoId = window.playlistPlayer.getVideoData().video_id;
      nextItem = $(".playlist-list li:has(a[data-video=" + videoId + "])").next("li");
      if(nextItem.length > 0) {
        nextVideoId = nextItem.find("a").data("video");
        window.playlistPlayer.loadVideoById(nextVideoId);
      }
    }
  }

  var createPlaylistPlayer = function() {
    origin = $('meta[name=youtube-origin]').attr("content");
    autoplay = $('meta[name=youtube-autoplay]').attr("content");
    firstItemData = $(".playlist-list li:first a").data();

    if(firstItemData)
      videoId = firstItemData.video;

    window.playlistPlayer = new YT.Player("playlist-player", {
      width: 640,
      height: 380,
      videoId: videoId,
      playerVars: {
        origin: origin,
        autoplay: autoplay,
        autohide: 1,
        rel: 0,
        showinfo: 1,
        enablejsapi: 1,
      },
      events: {
        onStateChange: playerStateChange
      }
    });
  }

  $(document).on("click", ".playlist-item", function() {
    videoId = $(this).data("video");
    window.playlistPlayer.loadVideoById({videoId: videoId });
  });

  $(document).on("youtubeReady", function() {
    if($("#playlist-player").length > 0) {
      createPlaylistPlayer();
    }
  });

  if($("#playlist-player").length > 0) {
    $.getScript("//youtube.com/iframe_api");
  };

});
