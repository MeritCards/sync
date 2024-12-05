require "test_helper"

class ArchivesControllerTest < ActionDispatch::IntegrationTest
  test "/my/archives/latest is most-recent backup" do
    user = User.find_by! email: "one@example.org"
    login

    get latest_archives_path
    assert_select "[data-version-number]", "1"

    user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    get latest_archives_path
    assert_select "[data-version-number]", "2"

    old_archive = user.archives.find_by! version_number: 1
    old_archive.promote!
    get latest_archives_path
    assert_select "[data-version-number]", "3"
  end

  private

  def login
    post login_path, params: { email: "one@example.org", password: "password" }
  end
end
