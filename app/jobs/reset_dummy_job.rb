class ResetDummyJob < ApplicationJob
  queue_as :default

  def perform
    dummy_user = User.find_by email: "dummy@example.org"
    dummy_user&.update_last_login
    dummy_user&.archives&.destroy_all
  end
end
