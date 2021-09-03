class User < ApplicationRecord
  before_validation {email.downcase!}
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  has_many :tasks, dependent: :destroy
  before_destroy :minimum_admin

  private
  def minimum_admin
    admin_account = User.all.select{|n| n.admin == true}
#    byebug
    if (admin_account.count == 1) && (admin_account[0].id == id)
      throw :abort
    end
  end
end
