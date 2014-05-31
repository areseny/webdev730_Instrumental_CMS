module HomeHelper

  def about_us_feature_image
    title = t("home.about_us.title")
    image_tag("aboutus-feature.jpg",
              size: '900x600', class: 'round', alt: title)
  end

  def about_us_feature_image_soundcheck
    image_tag("passagem-de-som-projeto.jpg", size: '900x600', class: 'round', alt: "Passagem de Som")
  end

  def about_us_sescsp_link
    title = t('links.sescsp.title')
    url = t('links.sescsp.url')
    image = image_tag("aboutus-logo-sescsp.jpg", size: '290x130',
                      class: 'round', alt: 'title')
    link_to image, url, target: '_blank', title: title
  end

  def about_us_sesctv_link
    title = t('links.sesctv.title')
    url = t('links.sesctv.url')
    image = image_tag("aboutus-logo-sesctv.jpg", size: '290x130',
                      class: 'round', alt: 'title')
    link_to image, url, target: '_blank', title: title
  end

end
