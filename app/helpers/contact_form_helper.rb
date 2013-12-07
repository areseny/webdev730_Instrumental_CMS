module ContactFormHelper

  def contact_form_facebook_link
    title = t('links.facebook.title')
    url = t('links.facebook.url')
    image = image_tag("contact-form-button-facebook.jpg",
                      alt: title, size: "132x126")
    link_to image, url, target: '_blank', title: title
  end

  def contact_form_twitter_link
    title = t('links.twitter.title')
    url = t('links.twitter.url')
    image = image_tag("contact-form-button-twitter.jpg",
                      alt: title, size: "132x126")
    link_to image, url, target: '_blank', title: title
  end

end
