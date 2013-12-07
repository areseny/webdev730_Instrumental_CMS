class Postman < ActionMailer::Base

  # TODO: specs

  def contact_form_acknowledgement(contact_form)
    from = format_email(t("from.name"),
                        t("from.email"))
    to = format_email(contact_form.name, contact_form.email)
    subject = t("subject")
    body = t("body")
    body.gsub!(/%NOME%/i, contact_form.name)
    body.gsub!(/%URL%/i, root_url)
    mail from: from, to: to, subject: subject,
         body: body, content_tpe: "text/plain"
  end

  def contact_form_notification(contact_form)
    from = format_email(contact_form.name, contact_form.email)
    to = format_email(t("to.name"), t("to.email"))
    subject = t("subject")
    body = t("body")
    body.gsub!(/%NOME%/i, contact_form.name)
    body.gsub!(/%EMAIL%/i, contact_form.email)
    body.gsub!(/%IP%/i, contact_form.ip_address)
    body.gsub!(/%MENSAGEM%/i, contact_form.message)
    mail from: from, to: to, subject: subject,
         body: body, content_tpe: "text/plain"
  end

  private

  def t(key)
    key = ["postman", caller_locations(1,1)[0].label, key].join(".")
    I18n.t(key)
  end

  def format_email(name, email)
    "#{name} <#{email}>"
  end

end
