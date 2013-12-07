module MarkdownHelper

  def markdown(text)
    raw redcarpet.render(text)
  end

  def markdown_t(*args)
    markdown t(*args)
  end

  private

  def redcarpet
    @redcarpet ||= create_renderer
  end

  def create_renderer
    renderer_options = {
      hard_wrap: true,
      filter_html: true,
      link_attributes: { target: "_blank" }
    }
    markdown_options = {
      strikethrough: true,
      highlight: true,
      underline: true
    }
    renderer = Redcarpet::Render::HTML.new(renderer_options)
    Redcarpet::Markdown.new(renderer, markdown_options)
  end

end
