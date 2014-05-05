module TitleHelper

  def title(text)
    @page_title = "#{text} | #{site_title}"
  end

  def page_title
    @page_title || site_title
  end

end
