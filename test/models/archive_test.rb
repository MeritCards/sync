require "test_helper"

class ArchiveTest < ActiveSupport::TestCase
  def setup
    @archive = Archive.new(user: User.first, version_number: 1)
  end

  test "version_number must be positive" do
    @archive.version_number = -1
    assert_not @archive.valid?
  end

  test "cannot have archive with same version_number" do
    user = User.find_by! email: "one@example.org"
    assert_raises(ActiveRecord::RecordInvalid) do
      Archive.create!(user: user, version_number: 1)
    end
  end
end
