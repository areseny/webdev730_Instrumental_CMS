module AdminHelper

  def glyphicon(icon, content = "")
    content_tag(:i, nil, class: "glyphicon glyphicon-#{icon}") + content
  end

end
