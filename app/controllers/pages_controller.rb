class PagesController < ApplicationController
  def home
  end

  def secured
    roles = session[:roles] || []
    unless roles.include?("user")
      return render plain: "Unauthorized", status: :unauthorized
    end

    @user_info = {
      user_id: session[:user_id],
      roles: roles,
      access_token: session[:access_token],
      id_token: session[:id_token]
    }

    render "secured"
  end

  def admin
    roles = session[:roles] || []
    unless roles.include?("admin")
      return render plain: "Unauthorized", status: :unauthorized
    end

    @user_info = {
      user_id: session[:user_id],
      roles: roles,
      access_token: session[:access_token],
      id_token: session[:id_token]
    }

    render "admin"
  end

  def logout
    # This just issues the POST/DELETE to the middleware’s /logout
    # Optional: clear session here as fallback
    reset_session
    redirect_to root_path, notice: "You have been logged out."
  end
end
