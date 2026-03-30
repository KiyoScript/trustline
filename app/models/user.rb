class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum :role, {
    super_admin: 0,
    admin:       1,
    manager:     2,
    agent:       3,
    viewer:      4
  }
end
