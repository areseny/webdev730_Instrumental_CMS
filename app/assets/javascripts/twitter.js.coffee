loadTwitter = -> $.getScript("//platform.twitter.com/widgets.js")

$(document)
  .ready(loadTwitter)
  .on("twitter:load", loadTwitter)
