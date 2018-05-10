# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord

  validates :user_name, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: {message: "Password can't be blank."}
  validates :password, length: {minimum: 6, allow_nil: true}
  after_initialize :ensure_session_token

  has_many :cats,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Cat

  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(user_name: username)
    return nil if user.nil? || !user.is_password?(password)
    user
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
    nil
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
