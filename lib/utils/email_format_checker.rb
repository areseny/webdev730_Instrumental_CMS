class EmailFormatChecker

  # TODO: specs

  def self.is_valid_email?(value)
    value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  end

end
