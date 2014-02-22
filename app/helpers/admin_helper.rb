module AdminHelper

  def glyphicon(icon, content = "")
    content_tag(:i, nil, class: "glyphicon glyphicon-#{icon}") + content
  end

  def fa_icon(icon, content = "", fixed: false)
    klasses = "fa fa-#{icon}"
    klasses << " fa-fw" if fixed
    content_tag(:i, nil, class: klasses) + content
  end

  def bootstrap_pager(collection)
    will_paginate(collection, renderer: BootstrapPagination::Rails, class: 'pull-right')
  end

  def admin_panel(title, &block)
    content = capture(&block)
    header = content_tag(:div, title, :class => "panel-heading")
    body = content_tag(:div, capture(&block), :class => "panel-body")
    content_tag(:div, header + body, :class => "panel panel-default")
  end

end
