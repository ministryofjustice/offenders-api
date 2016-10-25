class User < ActiveRecord::Base
  ROLES = %w(admin staff).freeze

  # Include default devise modules. Others available are:
  # :confirmable and :omniauthable
  devise :database_authenticatable, :lockable, :rememberable, :timeoutable, :trackable, :validatable

  validates :role, presence: true, inclusion: { in: ROLES }

  ROLES.each do |user_role|
    define_method "#{user_role}?" do
      role == user_role
    end
  end
end
