class Post < ApplicationRecord
  has_many :comments, -> {order(:created_at =>  :desc)}
  
  validates :content, {presence: true, length: {maximum: 140}}
  validates :user_id, {presence: true}
  

  
  def user
    return User.find_by(id: self.user_id)
  end
end
