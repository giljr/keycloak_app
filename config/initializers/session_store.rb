# config/initializers/session_store.rb

Rails.application.config.session_store :redis_store,
  servers: [
    {
      host: Rails.application.credentials.dig(:redis, :host) || "localhost",
      port: Rails.application.credentials.dig(:redis, :port) || 6379,
      db:   Rails.application.credentials.dig(:redis, :db_session) || 0,
      namespace: "sessions"
    }
  ],
  key: "_keycloak_app_session",
  expire_after: 90.minutes
  