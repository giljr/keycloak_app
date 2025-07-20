# config/initializers/session_store.rb

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
