class CleanUpJob < ApplicationJob
  queue_as :default

  def perform
    one_year_ago = 1.year.ago

    User.where(
      "(last_login IS NULL OR last_login < ?) AND created_at < ?",
      one_year_ago, one_year_ago
    ).destroy_all
  end
end
