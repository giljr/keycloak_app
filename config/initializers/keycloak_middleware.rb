Rails.application.config.middleware.use KeycloakMiddleware::Middleware do |config|            
  # Enable debug logging to terminal or Rails.logger
  config.debug = true

  # Configure the protected paths and required roles            
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
