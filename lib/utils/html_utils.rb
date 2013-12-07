module HtmlUtils

  def add_class_to_html_tag(tag, classes)
    if tag =~ /class="([^"]*)"/
      tag.gsub(/class="([^"]*)"/, %(class="\\1 #{classes}"))
    else
      tag.gsub(/(<[^\/>]+)/, %(\\1 class="#{classes}"))
    end
  end

end
