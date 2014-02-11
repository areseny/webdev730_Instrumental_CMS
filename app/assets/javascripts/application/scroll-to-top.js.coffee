jQuery ->
  $(document).on "click", ".scroll-to-top", ->
    $("html, body").animate scrollTop: 0
    false
