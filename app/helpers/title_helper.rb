module TitleHelper

  def title(text)
    @page_title = "#{text} | #{t("title")}"
  end

  def page_title
    @page_title || t("title")
  end

end
