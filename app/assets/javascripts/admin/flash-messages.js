jQuery(function($) {

  if($(".flash-messages").length > 0) {
    window.setTimeout(function() {
      $(".flash-messages").fadeOut('slow');
    }, 5000);
  }

});
