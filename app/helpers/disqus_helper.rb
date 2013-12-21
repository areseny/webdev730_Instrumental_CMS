module DisqusHelper

  def disqus_meta_tags
    tags = {
      "disqus-shortname" => ENV['DISQUS_SHORTNAME'],
      "disqus-baseurl" => ENV['DISQUS_BASEURL']
    }
    tags['disqus-developer'] = '1' if Rails.env.development?
    meta_tags tags
  end

  def disqus_comments(article)
    data = {
      disqus_identifier: article.disqus_identifier,
      disqus_title: article.disqus_title
    }
    output = content_tag(:div, nil, id: 'disqus_thread', data: data)
    output << content_tag(:noscript) { markdown_t("disqus.noscript") }
    output = debug(data) + output if Rails.env.development?
    output.html_safe
  end

end
