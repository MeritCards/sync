class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper

  # Disable full HTML layout for API requests
  # API request = Something that authenticates via basic auth
  layout -> { basic_auth_request? ? false : "application" }

  def index
    unless basic_auth_request?
      redirect_to login_path
    end
  end
end
