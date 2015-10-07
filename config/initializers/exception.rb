class Exception
  def print
    "#{self.message}\n #{self.backtrace.try(:join, "\n")}"
  end
end
