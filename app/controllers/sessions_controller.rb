class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :basic_auth_request?, only: [:create]
  before_action :is_logged_in?, only: [ :new, :create ]
  before_action :logged_in_user, only: [ :destroy ]

  def new
  end

  def create
    if basic_auth_request?
      authenticate_with_basic_auth
      render html: "#{@current_user&.token}".html_safe
      return
    end

    @email = params[:email].downcase
    @password = params[:password]
    user = User.find_by(email: @email)

    if user && user.authenticate(@password)
      log_in user
      user.update_last_login
      redirect_to user_path
    else
      flash.now[:danger] = "Invalid email/password combination"
      render "new", status: :unauthorized
    end
  rescue Exception
    # For all other cases, just assume authentication failed
    raise Errors::AuthenticationError.new
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def is_logged_in?
    if logged_in?
      redirect_to current_user
    end
  end
end
