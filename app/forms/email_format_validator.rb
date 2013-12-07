class EmailFormatValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    if value.present? || !options[:allow_blank?]
      if !EmailFormatChecker.is_valid_email?(value)
        object.errors.add(attribute, :email_format)
      end
    end
  end

end
