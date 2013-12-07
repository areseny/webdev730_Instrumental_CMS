jQuery ->
  if $("#recaptcha-box").length
    publicKey = $('meta[name=recaptcha-public-key]').attr("content")
    language = $('meta[name=recaptcha-language]').attr("content")
    url = "//www.google.com/recaptcha/api/js/recaptcha_ajax.js"
    $.getScript url, ->
      Recaptcha.create publicKey, "recaptcha-box", lang: language
