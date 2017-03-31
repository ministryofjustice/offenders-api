class User < ApplicationRecord
  ROLES = %w(admin staff).freeze

  validates :role, presence: true, inclusion: { in: ROLES }

  ROLES.each do |user_role|
    define_method "#{user_role}?" do
      role == user_role
    end
  end

  class << self
    def from_omniauth(auth)
      user = where(email: auth.info.email).first
      if user
        user.update_attributes(provider: auth.provider, uid: auth.uid)
      else
        user = first_or_create_by_uid_and_provider(auth)
      end
      user
    end

    private

    def first_or_create_by_uid_and_provider(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user_from_auth(user, auth)
      end
    end

    def user_from_auth(user, auth)
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.role = extract_role(auth.info.permissions)
    end

    def extract_role(permissions)
      permissions.first.roles.first || 'staff'
    end
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
