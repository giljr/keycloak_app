## 🔑 Keycloak Demo App

Demo Rails app showcasing authentication & authorization with Keycloak via the keycloak_middleware gem (v0.1.4).

```
🚀 Features
✅ Integrates with Keycloak using OpenID Connect.
✅ Middleware validates JWT and enforces required roles.
✅ Protects /secured and /admin endpoints.
✅ Role-based access control.
✅ Use Redis for to avoid browser cookie size limits.
```

📦 Installation
Clone and install dependencies:

```
git clone https://github.com/giljr/keycloak-app.git
cd keycloak-app
bundle install
```

Run database migrations if needed:

```
rails db:setup
```

🔧 Configuration
Set the following environment variables for Keycloak:

```
KEYCLOAK_REALM=quickstart
KEYCLOAK_SITE=http://localhost:8080
KEYCLOAK_CLIENT_ID=test-cli
KEYCLOAK_CLIENT_SECRET=EMdKUC82k9FHpY82J0beRsc8zjhhKsP0
KEYCLOAK_REDIRECT_URI=http://localhost:3000/auth/callback

REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_DB_SESSION=0
```

🔧 config/initializers/keycloak_middleware.rb:

```ruby
Rails.application.config.middleware.use KeycloakMiddleware::Middleware do |config|
  # Configure the protected paths and required roles
  config.debug = true
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
```

🔧 config/initializers/session_store.rb:

```ruby
Rails.application.config.session_store :cache_store,
  key: "_keycloak_app_session",
  expire_after: 90.minutes

```

🛣️ Routes

Method Path Description

```
GET	/public	    Public page
GET	/secured	Requires user role
GET	/admin	    Requires admin role
```

🧪 Run
Start the server:

```
bin/dev
```

Or simply:

```
rails server
```

Visit: http://localhost:3000

#### 🔗 Middleware

This app uses the [Keycloak::Middleware](https://github.com/giljr/keycloak_middleware) to intercept requests and validate JWT tokens for `/secured` and `/admin`.

You can customize required roles in `config/initializers/keycloak_middleware.rb`.

📄 License
MIT