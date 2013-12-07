class Subscriber < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true,
            uniqueness: { message: "já está cadastrado em nossa newsletter!" },
            email_format: { allow_blank: true }
end
