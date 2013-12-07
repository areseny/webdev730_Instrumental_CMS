class ContactMessage < ActiveRecord::Base

  def self.send_form(form)
    if form.valid?
      transaction do |t|
        create!(name: form.name, email: form.email,
                ip_address: form.ip_address, message: form.message)
        Postman.contact_form_notification(form).deliver
      end
      Postman.contact_form_acknowledgement(form).deliver
    end
  end

end
