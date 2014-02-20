jQuery(function($) {

  if(window.location.href.indexOf("/aovivo") == -1) {
    $.get("/live_status.json", function(data) {
      if(data.id) {
        $("#live-artist").html(data.artist);
        $(".alert-live").slideDown('fast');
      }
    });
  }

});
