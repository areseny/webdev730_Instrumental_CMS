module ApplicationHelper

  # Overrides default implementation to use custom FormBuilder
  def form_for(*args)
    options = args.extract_options!
    super *(args << options.merge!(builder: FormBuilder))
  end

  def meta_tags(values = {})
    tags = values.map do |name, content|
      tag('meta', name: name, content: content)
    end
    tags.join.html_safe
  end

  def meta_properties(values = {})
    tags = values.map do |name, content|
      tag('meta', property: name, content: content)
    end
    tags.join.html_safe
  end

  def definition_list(items, options = {})
    tags = items.map do |key, value|
      content_tag(:dt, key) + content_tag(:dd, value)
    end
    content_tag(:dl, tags.join.html_safe, options)
  end

  def sound_check_domain?
    request.host == "passagemdesom.sesctv.org.br"
  end

  def site_title
    if sound_check_domain?
      "Passagem de Som"
    else
      "Instrumental SESC Brasil"
    end
  end

end
