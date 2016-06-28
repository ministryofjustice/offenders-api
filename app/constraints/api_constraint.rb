class ApiConstraint
  attr_reader :version

  def initialize(options)
    @version = options.fetch(:version)
  end

  def matches?(request)
    return true if Rails.env.development?

    request
      .headers
      .fetch(:accept)
      .include?("version=#{version}")
  end
end
