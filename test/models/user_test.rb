require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create! email: "user@example.com",
                         password: "password", password_confirmation: "password"
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
