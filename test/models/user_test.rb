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

  test "token can only exist once" do
    User.create! email: "user1@example.com",
                 password: "password", password_confirmation: "password",
                 token: "token1"

    assert_raises ActiveRecord::RecordNotUnique do
      User.create! email: "user2@example.com",
                   password: "password", password_confirmation: "password",
                   token: "token1"
    end
  end

  test "current_archive gets highest version number" do
    @user.archives.create! version_number: 3
    @user.archives.create! version_number: 1

    assert @user.current_archive.version_number == 3
  end

  test "can only add 7 archives" do
    7.times do
      @user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    end

    @user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"

    assert @user.archives.count == 7
    assert @user.archives[0].version_number == 2
    assert @user.archives[1].version_number == 3
    assert @user.archives[2].version_number == 4
    assert @user.archives[3].version_number == 5
    assert @user.archives[4].version_number == 6
    assert @user.archives[5].version_number == 7
    assert @user.archives[6].version_number == 8
  end

  test "Cannot add backup if no space left" do
    @user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    @user.archives.last.file.blob.update byte_size: 1024 * 1024 * 1024

    assert_raises User::NoSpaceError do
      @user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    end
  end
end
