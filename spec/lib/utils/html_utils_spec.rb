require "utils/html_utils"
require 'capybara/rspec'

describe HtmlUtils do
  include HtmlUtils
  include Capybara::RSpecMatchers

  describe "#add_class_to_html_tag" do
    it "adds a class to a closed html tag" do
      tag = %(<input type="text" foo="bar"/>)
      result = add_class_to_html_tag(tag, "foo bar")
      result.should have_css("input.foo.bar[type='text']")
    end

    it "adds a class to an open html tag" do
      tag = %(<textarea foo="bar">Content</textarea>)
      result = add_class_to_html_tag(tag, "foo bar")
      result.should have_css("textarea.foo.bar", text: /Content/)
    end

    it "updates the classes of a closed html tag" do
      tag = %(<input type="text" class="c1 c2" foo="bar"/>)
      result = add_class_to_html_tag(tag, "foo bar")
      result.should have_css("input.c1.c2.foo.bar[type=text]")
    end

    it "updates the classes of an open html tag" do
      tag = %(<textarea class="k1 k2" foo="bar">Content</textarea>)
      result = add_class_to_html_tag(tag, "foo bar")
      result.should have_css("textarea.k1.k2.foo.bar", text: /Content/)
    end
  end

end
