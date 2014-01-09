module AdminHelper

  def glyphicon(icon, content = "")
    content_tag(:i, nil, class: "glyphicon glyphicon-#{icon}") + content
  end

  def bootstrap_pager(collection)
    will_paginate(collection, renderer: BootstrapPagination::Rails, class: 'pull-right')
  end

end
