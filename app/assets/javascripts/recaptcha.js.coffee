createRecaptcha = ->
  publicKey = $('meta[name=recaptcha-public-key]').attr("content")
  language = $('meta[name=recaptcha-language]').attr("content")
  Recaptcha.create publicKey, "recaptcha-box", lang: language

jQuery ->
  if $("#recaptcha-box").length
    $.getScript "//www.google.com/recaptcha/api/js/recaptcha_ajax.js", createRecaptcha

$(document).on "recaptcha:create", createRecaptcha
