class PagesController < ApplicationController
  before_action :set_user_info, only: %i[secured admin]

  def secured
    if user_has_role?("user")
      @logout_jwt = @user_info[:access_token]
      render "secured"
    else
      unauthorized
    end
  end

  def admin
    if user_has_role?("admin")
      @logout_jwt = @user_info[:access_token]
      render "admin"
    else
      unauthorized
    end
  end

  private

  def set_user_info
    @user_info = {
      user_id: session[:user_id],
      roles: session[:roles] || [],
      access_token: session[:access_token]
    }
  end

  def user_has_role?(role)
    @user_info[:roles].include?(role)
  end

  def unauthorized
    render plain: "Unauthorized", status: :unauthorized
  end
end
