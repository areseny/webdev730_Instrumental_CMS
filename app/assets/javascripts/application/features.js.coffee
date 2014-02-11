jQuery ($) ->

  $(".feature-carousel").jcarousel
    wrap: 'circular'
  .jcarouselAutoscroll
    interval: 10000
    target: '+=1'
    autostart: true
  .on 'jcarousel:targetin', 'li', ->
    title = $(this).data("title")
    description = $(this).data("description")
    $("#feature-carousel-title").hide().html(title).fadeIn('slow')
    $("#feature-carousel-description").hide().html(description).fadeIn('slow')
