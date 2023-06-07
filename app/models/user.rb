class User < ApplicationRecord
    has_many :documents

    validates :name, :presence => true
    validates :email, :presence => true, :uniqueness => true, :format => { with: URI::MailTo::EMAIL_REGEXP }
    validates :user_name, :presence => true, :uniqueness => true

    attr_accessor :password
    before_save :encrypt_password

    def encrypt_password
        if password.present?
            self.password_digest = BCrypt::Password.create(password)
        end
    end

    def authenticate(entered_password)
        BCrypt::Password.new(password_digest) == entered_password
    end

end
