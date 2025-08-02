
# Keycloak Middleware Demo - v0.2.0
### Welcome to this SECOND tutorial!

✅ This time, we use Rails credentials instead of a .env file — following Rails best practices (BCP).

Update: [aug, 25]
#### Using keycloak_middleware Gem v0.2.0! from [here](https://medium.com/jungletronics/a-rails-gem-from-scratch-41b5cbbd9453)



👉 Start from [here](https://medium.com/jungletronics/keycloak-middleware-demo-a122a5fcf3bf).

Then update the app like these instructions:

You’ll learn:
```
✅ Use Rails BCP
✅ How the gem works behind the scenes
✅ How to configure it in your Rails app
✅ Tips to test and debug your middleware
✅ Best practices to secure your endpoints with Keycloak
```
### 🚀 UPDATE [2025–07–30]: Upgrade to keycloak_middleware v0.2.0

Version v0.2.0 introduces major enhancements, including full support for Rails.application.credentials, removal of the .env dependency, and improved session/logout handling using JWT.

Follow the steps below to upgrade your Rails project:
---
#### ✅ 0. Update Your Gemfile

Replace the previous gem version with the latest tag:
```bash
gem "keycloak_middleware", git: "https://github.com/giljr/keycloak_middleware. git", tag: "v0.2.0"
```

Then install the gem:

```bash
bundle install
```
You should see:
```bash
Fetching https://github.com/giljr/keycloak_middleware.git
Fetching gem metadata from https://rubygems.org/.........
Resolving dependencies...
Using keycloak_middleware 0.2.0 (was 0.1.7) from https://github.com/giljr/keycloak_middleware.git (at v0.2.0@caf561c)
Bundle complete! 28 Gemfile dependencies, 130 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.

3 installed gems you directly depend on are looking for funding.
  Run `bundle fund` for details
```
---
#### ✅ 1. Recreate Your Credentials File (Recommended)

If you don’t need the previous encrypted credentials, reset them from scratch:
```bash
rm config/credentials.yml.enc config/master.key
EDITOR=”code — wait” bin/rails credentials:edit
```
---
####  ✅ 2. Add Keycloak and Redis Configuration

In the editor window that opens, paste the following YAML structure:
```yml
keycloak:
  realm: <your_realm_name>
  site: https://<your_keycloak_server>
  client_id: <your_client_id>
  client_secret: <your_secret>
  redirect_uri: http://<your_app_url>:<port>/auth/callback

redis:
  host: <redis_server_url>
  port: 6379
  db_session: 0

secret_key_base: <your_secret_key_base>
```
Replace values as appropriate for your environment

---

#### ✅ 3. Update

`config/initializers/session_store.rb`

Modify your session store to read Redis credentials from the encrypted file:
```ruby
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
```
After following these steps, your app should function as before — now with improved security and maintainability.

---

#### ✅ 4. Configure the logout redirect URI in the Keycloak dashboard

In your client settings, add the following to Valid Redirect URIs:

http://localhost:8080/logout

Click Save to apply the changes.

You're all set! 👌
#### 💡 If anything breaks, blame the upgrade… or just ping the maintainer 😉

---

## Tutorials - Get Started!

[**A Rails Gem From Scratch**](https://medium.com/jungletronics/a-rails-gem-from-scratch-41b5cbbd9453) - 
Building a Keycloak Middleware Gem for Rails 8+

[**Keycloak Middleware Demo In Rails 8**](https://medium.com/jungletronics/keycloak-middleware-demo-a122a5fcf3bf) - Using keycloak_middleware Gem

Gem: **[keycloak:middleware](https://github.com/giljr/keycloak_middleware)**



    
## Support

- +rails 8.0.2
- +ruby-3.4.4
