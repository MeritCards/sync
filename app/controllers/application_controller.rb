class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper

  rescue_from Errors::AuthenticationError, with: :unauthorized

  # Disable full HTML layout for API requests
  # API request = Something with a Bearer token
  layout -> { (basic_auth_request? || token_request?) ? false : "application" }

  def index
    if token_request?
      authenticate_with_token
    elsif basic_auth_request?
      authenticate_with_basic_auth
    else
      raise Errors::AuthenticationError.new
    end
  end

  private

  def unauthorized
    render html: "<p>Not authenticated</p>".html_safe, status: :unauthorized
  end
end
