class User < ApplicationRecord
  
  has_secure_password
  has_many :comments
  
  validates :name, {presence: true}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :profile, length: {maximum: 70}
  def posts
    return Post.where(user_id: self.id)
  end
  
end
  
