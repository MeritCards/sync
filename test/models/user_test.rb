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
    assert @user.archives.first!.version_number == 2
  end

  test "Cannot add backup if no space left" do
    @user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    @user.archives.last.file.blob.update byte_size: 1024*1024*1024

    assert_raises User::NoSpaceError do
      @user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    end
  end
end
