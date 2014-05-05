module LayoutHelper

  def header_logo
    if sound_check_domain?
      image = image_tag("soundcheck-logo.jpg", size: '124x114', alt: site_title)
    else
      image = image_tag("header-logo.png", size: '220x120', alt: site_title)
    end
    link_to image, root_path, title: site_title, class: "header-logo"
  end

  def footer_facebook_link
    title = t('links.facebook.title')
    url = t('links.facebook.url')
    image = image_tag("footer-button-facebook.jpg", alt: title, size: "61x61")
    link_to image, url, target: '_blank', title: title
  end

  def footer_twitter_link
    title = t('links.twitter.title')
    url = t('links.twitter.url')
    image = image_tag("footer-button-twitter.jpg", alt: title, size: "61x61")
    link_to image, url, target: '_blank', title: title
  end

  def footer_sescsp_link
    title = t('links.sescsp.title')
    url = t('links.sescsp.url')
    image = image_tag("footer-logo-sescsp.jpg", size: '138x28', alt: title)
    link_to image, url, target: '_blank', title: title
  end

  def footer_sesctv_link
    title = t('links.sesctv.title')
    url = t('links.sesctv.url')
    image = image_tag("footer-logo-sesctv.jpg", size: '69x21', alt: title)
    link_to image, url, target: '_blank', title: title
  end

  def footer_privacy_link
    title = t("home.privacy.title")
    link_to title, privacy_path, title: title
  end

end
