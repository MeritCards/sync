module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def logged_in_user
    unless logged_in?
      redirect_to login_url
    end
  end

  def authenticate
    if basic_auth_request?
      authenticate_with_basic_auth
    else
      logged_in_user
    end
  end

  def authenticate_with_basic_auth
    email, password = ActionController::HttpAuthentication::Basic.user_name_and_password(request)

    if email && password
      user = User.find_by(email: CGI::unescape(email))
      if user&.authenticate(password)
        @current_user = user
      else
        render_unauthorized
      end
    else
      render_unauthorized
    end
  end
end
