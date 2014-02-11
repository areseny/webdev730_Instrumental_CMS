root = exports ? this

jQuery ->
  thread = $("#disqus_thread")
  if thread.length && !DISQUS?
    root.disqus_shortname = $('meta[name=disqus-shortname]').attr("content")
    root.disqus_developer = $('meta[name=disqus-developer]').attr("content")
    root.disqus_identifier = thread.data("disqusIdentifier")
    root.disqus_title = thread.data("disqusTitle")
    baseurl = $('meta[name=disqus-baseurl]').attr("content")
    root.disqus_url = "#{baseurl}/artistas/#{root.disqus_identifier}"
    $.ajax
      type: "GET"
      url: "//#{root.disqus_shortname}.disqus.com/embed.js"
      dataType: "script"
      cache: true
