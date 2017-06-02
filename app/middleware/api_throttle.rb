class ApiThrottle < Rack::Throttle::Minute
  def allowed?(request)
    path_info = (Rails.application.routes.recognize_path request.url rescue {}) || {}
    path_info[:controller] =~ /^api\// ? super : true
  end
end
