class ContactFormController < ApplicationController
  layout :choose_layout_based_on_xhr

  # GET /contato
  def contact_form
    @contact_form = ContactForm.new
  end

  # POST /contato
  def contact
    @contact_form = ContactForm.new(contact_form_params)
    if ContactMessage.send_form(@contact_form)
      flash.now[:success] = "contact_form.success"
      render :success
    else
      flash.now[:error] = "contact_form.error"
      render :contact_form
    end
  end

  private

  def contact_form_params
    params[:contact_form]
      .permit(:name, :email, :message)
      .merge(ip_address: request.remote_ip,
             captcha_challenge: params[:recaptcha_challenge_field],
             captcha: params[:recaptcha_response_field])
  end

  def choose_layout_based_on_xhr
    request.xhr? ? false : "contact_form"
  end

end
