module ApplicationHelper
  def basic_auth_request?
    request.authorization.present? && request.authorization.start_with?("Basic ")
  end

  def render_unauthorized
    headers["WWW-Authenticate"] = 'Basic realm="Application"'
    render html: "<p>Not authenticated</p>".html_safe, status: :unauthorized
  end
end
