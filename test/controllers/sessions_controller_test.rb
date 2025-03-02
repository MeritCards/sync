require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "can get /login" do
    get login_path
    assert_response :success
  end

  test "incorrect POST to /login" do
    post login_path, headers: { HTTP_AUTHORIZATION: "Basic abc" }
    assert_response :unauthorized
  end

  test "can authenticate with basic auth" do
    post login_path, headers: headers
    assert_response :success
  end

  test "login with basic auth returns token" do
    post login_path, headers: headers
    assert_equal "CbUJiEeNKsLyauap6XaZhcA1", @response.body
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
end
