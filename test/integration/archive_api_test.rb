require "test_helper"

class ArchiveApiTest < ActionDispatch::IntegrationTest
  test "can upload a database" do
    user = User.find_by! email: "one@example.org"
    database = fixture_file_upload("MeritCards-Icon.png")
    post archives_path,
         params: { archive: { file: database } },
         headers: headers

    assert_response :redirect
    follow_redirect! headers: headers
    assert_response :success
    assert_select "h2", "Backups"
    assert user.archives.count == 3
  end

  test "can delete a backup" do
    user = User.find_by! email: "one@example.org"
    archive = user.add_file io: StringIO.new("dummy file"), filename: "dummy_file"
    count = user.archives.count

    delete archive_path(archive.version_number), headers: headers

    assert user.archives.count == count - 1
  end

  private

  def headers
    { HTTP_AUTHORIZATION: "Bearer CbUJiEeNKsLyauap6XaZhcA1" }
  end
end
