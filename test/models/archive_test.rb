require "test_helper"

class ArchiveTest < ActiveSupport::TestCase
  def setup
    @archive = Archive.new(user: User.first, version_number: 1)
  end

  test "version_number must be positive" do
    @archive.version_number = -1
    assert_not @archive.valid?
  end
end
