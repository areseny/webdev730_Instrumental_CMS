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

end
