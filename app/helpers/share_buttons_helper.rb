module ShareButtonsHelper

  def twitter_share_button(text, options = {})
    data = options.reverse_merge(:text => text)
    link_to "Twitter", '#',
            :class => 'share-twitter', :title => "Compartilhe no Twitter",
            :data => data
  end

  def facebook_share_button(options = {})
    link_to "Facebook", '#',
            :class => 'share-facebook', :title => "Compartilhe no Facebook",
            :data => options
  end

  def google_plus_share_button(options = {})
    link_to "Google Plus", '#',
            :class => 'share-google-plus',
            :title => "Compartilhe no Google Plus",
            :data => options
  end

  def email_share_button(subject, body)
    mail_to "", "E-mail", :class => 'share-email', :title => "Compartilhe via E-mail",
                :body => body, :subject => subject
  end

end
