Rails.application.config.middleware.use KeycloakMiddleware::Middleware do |config|
  # Configure the protected paths and required roles
  config.debug = false
  config.protect "/secured", role: "user"
  config.protect "/admin", role: "admin"

  # Configure the redirection logic on successful login
  config.on_login_success = proc do |roles|
    if roles.include?('admin')
      '/admin'
    elsif roles.include?('user')
      '/secured'
    else
      '/'
    end
  end
end
