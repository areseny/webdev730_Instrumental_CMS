module ScheduleHelper

  def home_schedule_tab(show, selected = false)
    content =
      content_tag(:h5, show.artist.name) +
      content_tag(:small, l(show.date, format: :tiny))
    link = link_to content, "##{show.slug}", class: (selected ? "tab tab-selected" : "tab")
    div_classes = selected ? 'schedule-tab schedule-tab-selected' : 'schedule-tab'
    content_tag :div, link, class: div_classes
  end

  def home_schedule_panel(show, selected = false, &block)
    content = capture(&block)
    classes = "schedule-tab-panel tab-panel"
    classes << " tab-panel-selected" if selected
    content_tag :div, content, class: classes, id: show.slug
  end

end
