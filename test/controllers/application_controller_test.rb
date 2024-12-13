require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "cannot get index without authentication" do
    get root_path
    assert_response :unauthorized
  end

  test "can get index with basic auth" do
    get root_path, headers: headers
    assert_response :success
  end

  test "can get index with token" do
    get root_path, headers: { HTTP_AUTHORIZATION: "Bearer CbUJiEeNKsLyauap6XaZhcA1" }
    assert_response :success
  end

  private

  def headers
    {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(
        "one%40example.org",
        "password"
      )
    }
  end

  def login
    post login_path, params: { email: "one@example.org", password: "password" }
  end
end
