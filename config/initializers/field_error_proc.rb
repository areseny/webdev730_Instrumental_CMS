helper = Object.new.extend(HtmlUtils)
ActionView::Base.field_error_proc = Proc.new do |tag, instance|
  helper.add_class_to_html_tag(tag, "field-with-errors").html_safe
end
