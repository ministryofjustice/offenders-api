class User < ActiveRecord::Base
  ROLES = %w[ admin staff ]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable, :rememberable, :trackable, :validatable

  validates :role, presence: true, inclusion: { in: ROLES }

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end
end
