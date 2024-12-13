module ApplicationHelper
  def basic_auth_request?
    request.authorization.present? && request.authorization.start_with?("Basic ")
  end

  def token_request?
    auth_header = request.headers["Authorization"]
    auth_header.present? && auth_header.start_with?("Bearer ")
  end

  def svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end
end
