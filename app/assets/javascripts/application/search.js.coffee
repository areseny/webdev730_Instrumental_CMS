enableOrDisableSearchButton = ->
  if $.trim($(".search-form-input").val())
    $(".search-form-submit").prop('disabled', false);
  else
    $(".search-form-submit").prop('disabled', true)

$(document).ready(enableOrDisableSearchButton)
           .on("page:load", enableOrDisableSearchButton)
           .on("keyup", ".search-form-input", enableOrDisableSearchButton)
