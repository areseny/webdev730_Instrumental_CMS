module ShareButtonsHelper

  def twitter_share_button(text)
     link_to "Twitter", '#',
             :class => 'share-twitter', :title => "Compartilhe no Twitter",
             :data => { :text => text }
  end

  def facebook_share_button
    link_to "Facebook", '#', :class => 'share-facebook', :title => "Compartilhe no Facebook"
  end

  def google_plus_share_button
    link_to "Google Plus", '#', :class => 'share-google-plus', :title => "Compartilhe no Google Plus"
  end

  def email_share_button(subject, body)
    mail_to "", "E-mail", :class => 'share-email', :title => "Compartilhe via E-mail",
                :body => body, :subject => subject
  end

end
