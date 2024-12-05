module ApplicationHelper
  def basic_auth_request?
    request.authorization.present? && request.authorization.start_with?("Basic ")
  end

  def render_unauthorized
    headers["WWW-Authenticate"] = 'Basic realm="Application"'
    render html: "<p>Not authenticated</p>".html_safe, status: :unauthorized
  end

  def svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end
end
