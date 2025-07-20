
Rails.application.routes.draw do
  root "pages#index"

  get "public",            to: "pages#public"
  get   "/login",          to: redirect("/") # Middleware handles /login
  match "/logout",         to: "pages#logout", via: [:post, :delete]
  get   "/auth/callback",  to: redirect("/") # Middleware handles /auth/callback

  get "/secured", to: "pages#secured"
  get "/admin",   to: "pages#admin"
end
