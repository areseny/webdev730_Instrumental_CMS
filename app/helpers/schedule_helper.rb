module ScheduleHelper

  def home_schedule_tab(item, selected = false)
    content =
      content_tag(:h5, item.artist.name) +
      content_tag(:small, l(item.date, format: :tiny))
    link = link_to content, "#schedule-#{item.date.to_s}", class: (selected ? "tab tab-selected" : "tab")
    div_classes = selected ? 'schedule-tab schedule-tab-selected' : 'schedule-tab'
    content_tag :div, link, class: div_classes
  end

  def home_schedule_panel(item, selected = false, &block)
    content = capture(&block)
    classes = "schedule-tab-panel tab-panel"
    classes << " tab-panel-selected" if selected
    content_tag :div, content, class: classes, id: "schedule-#{item.date.to_s}"
  end

  def closest_schedule_item(items)
    items.each do |item|
      return item if item.date >= Date.current
    end
    return items.last
  end

end
