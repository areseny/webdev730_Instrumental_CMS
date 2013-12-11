module FeaturesHelper

  def feature_subtitle(feature)
    featurable = feature.featurable
    if featurable.is_a?(Event)
      human_name = featurable.class.model_name.human
      title = human_name + "<br/>" + l(featurable.date)
      content_tag :h2, link_to(title.html_safe, feature.reference)
    end
  end

end
