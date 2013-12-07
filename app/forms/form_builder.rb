class FormBuilder < ActionView::Helpers::FormBuilder

  def error_message_for(attribute)
    errors = object.errors.messages[attribute] || []
    if errors.one?
      h.content_tag(:div, errors[0], class: 'field-error-message')
    elsif errors.any?
      h.content_tag(:ul, class: 'field-error-message') do
        errors.map { |msg| h.content_tag(:li, msg) }.join.html_safe
      end
    end
  end

private
  def h
    @template
  end

end
