jQuery(function($) {

  var openPopup = function(url, width, height) {
    leftPos = window.screenLeft + 100;
    if(leftPos > window.screen.width)
      leftPos = window.screen.width - width;
    if(leftPos < 0)
      leftPos = 0;
    topPos = window.screenTop + 100;
    if(topPos > window.screen.height)
      topPos = window.screen.height - height;
    if(topPos < 0)
      topPos = 0
    window.open(url, '', 'menubar-no,toolbar-no,resizable=no,scrollbars=no,height=' + height + ',width=' + width + ',top=' + topPos + ',left=' + leftPos);
    return false;
  }

  $(".share-twitter").click(function() {
    text = $(this).data("text");
    share_url = $(this).data("url") || window.location.href;
    url = "http://twitter.com/home?status=" + escape(text) + "+" + escape(share_url);
    return openPopup(url, 600, 400);
  });

  $(".share-facebook").click(function() {
    app_id = $('meta[name=facebook-app-id]').attr("content");
    share_url = $(this).data("url") || window.location.href;
    url = "http://www.facebook.com/sharer.php?u=" + escape(share_url) + '&app_id=' + app_id + '&display=popup';
    return openPopup(url, 680, 400);
  });

  $(".share-google-plus").click(function() {
    share_url = $(this).data("url") || window.location.href;
    url = "https://plus.google.com/share?url=" + escape(share_url);
    return openPopup(url, 600, 400);
  });

});
