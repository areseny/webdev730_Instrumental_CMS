class FormBuilder < ActionView::Helpers::FormBuilder

  def horizontal_group(field, method, options = {})
    classes = %w(form-group)
    control_size = options[:control_size] || 'col-sm-10'
    control_classes = options.delete(:class).try(:split, ' ') || []
    control_classes << 'form-control'
    control = send(method, field, options.merge(:class => control_classes.join(' ')))
    if object.errors[field].any?
      classes << "has-error"
      help_block = h.simple_format(object.errors.full_messages_for(field)[0])
      control = control + h.content_tag(:span, help_block, class: 'help-block')
    end
    content =
      label(field, class: 'col-sm-2 control-label') +
      h.content_tag(:div, control, class: control_size)
    h.content_tag :div, content, class: classes.join(' ')
  end

  def horizontal_check_box(field, text)
    check_box_label = h.content_tag(:label, check_box(field) + text)
    check_box_div = h.content_tag(:div, check_box_label, class: 'checkbox')
    content = h.content_tag(:div, check_box_div, class: 'col-sm-offset-2 col-sm-10')
    h.content_tag :div, content, class: 'form-group'
  end

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

  def admin_field(attribute, options = nil)
    column = object.class.columns_hash[attribute.to_s]
    options ||= {}
    if column
      h.render("admin/fields/#{column.type}_field",
               :form => self, :attribute => attribute, :options => options)
    else
      if association = object.class.reflect_on_association(attribute.to_sym)
        h.render("admin/fields/#{association.name}_field",
                 :form => self, :attribute => attribute, :options => options)
      else
        h.content_tag(:span, "Unknown attribute: #{attribute}")
      end
    end
  end

private
  def h
    @template
  end

end
