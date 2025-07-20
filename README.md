## 🔑 Keycloak Demo App

Demo Rails app showcasing authentication & authorization with Keycloak via the keycloak_middleware gem (v0.1.4).


🚀 Features
```
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

🔧 Configuration
Set the following environment variables for Keycloak:

```
touch .env
```
```ruby
KEYCLOAK_REALM=<your_realm_name>
KEYCLOAK_SITE=<keycloak_server_url>           # e.g., http://localhost:8080
KEYCLOAK_CLIENT_ID=<your_client_name>
KEYCLOAK_CLIENT_SECRET=<your_client_secret_key>
KEYCLOAK_REDIRECT_URI=<redirect_url>           # e.g., http://localhost:3000/auth/callback

REDIS_HOST=<your_redis_server_url>             # e.g., localhost
REDIS_PORT=6379
REDIS_DB_SESSION=0
```
#### 🔎 To grasp how it works, examine these files:

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
Rails.application.config.session_store :redis_store,
  servers: [
    {
      host: ENV.fetch("REDIS_HOST", "localhost"),
      port: ENV.fetch("REDIS_PORT", 6379),
      db:   ENV.fetch("REDIS_DB_SESSION", 0),
      namespace: "sessions"
    }
  ],
  key: "_keycloak_app_session",
  expire_after: 90.minutes
```

#### 🛣️ Routes

🔧 config/routes.rb
```ruby
Rails.application.routes.draw do
  root "pages#index"

  get   "public",          to: "pages#public"
  get   "/login",          to: redirect("/") # Middleware handles /login
  match "/logout",         to: "pages#logout", via: [:post, :delete]
  get   "/auth/callback",  to: redirect("/") # Middleware handles /auth/callback

  get   "/secured",        to: "pages#secured"
  get   "/admin",          to: "pages#admin"
end
```

🔧 Method Path Description

```
GET	/public	    Public page
GET	/secured	  Requires token - user role
GET	/admin	    Requires token - admin role
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

You’ll be redirected to the Keycloak login page. After entering your credentials, you’ll land on either the /secured or /admin endpoints. 

Voilà!

#### 🔗 Middleware

This app uses the [Keycloak::Middleware](https://github.com/giljr/keycloak_middleware) to intercept requests and validate JWT tokens for `/secured` and `/admin`.

You can customize required roles in `config/initializers/keycloak_middleware.rb`.

You can turn on debug mode to see the [OAuth 2.0](https://medium.com/jungletronics/demystifying-oauth-2-0-flow-unleashed-b6d1e652bbd5) artifacts printed in the terminal.

📄 License

MIT