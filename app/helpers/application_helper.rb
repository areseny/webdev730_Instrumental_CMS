module ApplicationHelper

  def meta_tags(values = {})
    tags = values.map do |name, content|
      tag('meta', name: name, content: content)
    end
    tags.join.html_safe
  end

end
