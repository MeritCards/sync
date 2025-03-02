require "test_helper"

class ArchivesControllerTest < ActionDispatch::IntegrationTest
  test "/my/archives lists backups" do
    login
    get archives_path
    assert_dom "table.form-table tr[data-archive]", 2
  end

  test "/my/archives with no backups" do
    post login_path, params: { email: "two@example.org", password: "password" }
    get archives_path
    assert_dom "table.form-table tr", 0
  end

  test "/my/archives/1 for own archive" do
    login
    get archive_path(1)
    assert_response :success
  end

  test "/my/archives/{non-existing archive}" do
    login
    get archive_path(-123123)
    assert_response :not_found
  end

  test "/my/archives/{number} is version_number, not ID" do
    login
    get archive_path(1)
    assert_response :success

    user = User.find_by! email: "one@example.org"
    archive = user.archives.find_by! version_number: 1
    archive.update! version_number: 123

    get archive_path(1)
    assert_response :not_found

    get archive_path(123)
    assert_response :success
  end

  test "/my/archives/latest is most-recent backup" do
    user = User.find_by! email: "one@example.org"
    login

    get latest_archives_path
    assert_select "[data-version-number]", "2"

    # Add a new archive
    user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    get latest_archives_path
    assert_select "[data-version-number]", "3"

    # Promote an existing archive to latest one
    old_archive = user.archives.find_by! version_number: 1
    old_archive.promote!
    get latest_archives_path
    assert_select "[data-version-number]", "4"
  end

  private

  def login
    post login_path, params: { email: "one@example.org", password: "password" }
  end
end
