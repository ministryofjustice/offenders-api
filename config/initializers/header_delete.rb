class HeaderDelete
  def initialize(app, options = {})
    @app, @options = app, options
  end

  def call(env)
    r = @app.call(env)

    #[status, headers, response] = r

    r[1].delete "Date"
    r[1].delete "Server"
    r[1].delete "X-Runtime"
    r[1].delete "X-Request-Id"
    r[1].delete "ETag"
    r
  end
end

Rails.application.config.middleware.insert_before(ActionDispatch::Static, HeaderDelete)
