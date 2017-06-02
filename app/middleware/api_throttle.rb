class ApiThrottle < Rack::Throttle::Minute
  def allowed?(request)
    begin
      path_info = Rails.application.routes.recognize_path request.url || {}
    rescue
      path_info = {}
    end

    path_info[:controller] =~ %r{^api/} ? super : true
  end
end
