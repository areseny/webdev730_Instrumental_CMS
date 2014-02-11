fb_root = null
fb_events_bound = false

$(document).ready ->
  loadFacebookSDK()
  bindFacebookEvents() unless fb_events_bound

$(document).on("facebook:parse", -> FB?.XFBML.parse())

bindFacebookEvents = ->
  $(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', -> $(document).trigger('facebook:parse'))
  fb_events_bound = true

saveFacebookRoot = ->
  fb_root = $('#fb-root').detach()

restoreFacebookRoot = ->
  if $('#fb-root').length > 0
    $('#fb-root').replaceWith fb_root
  else
    $('body').append fb_root

loadFacebookSDK = ->
  $('body').append($("<div id='fb-root'></div>"))
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/pt_BR/all.js#xfbml=1")

initializeFacebookSDK = ->
  FB.init
    appId     : $('meta[name=facebook-app-id]').attr("content")
    channelUrl: $('meta[name=facebook-channel-url]').attr("content")
    status    : true
    cookie    : true
    xfbml     : true
