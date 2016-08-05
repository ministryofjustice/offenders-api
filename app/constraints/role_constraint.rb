class RoleConstraint
  def initialize(role)
    @role = role.to_s
  end

  def matches?(request)
    @role == request.env['warden'].user(:user).try(:role)
  end
end
