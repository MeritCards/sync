class User < ActiveRecord::Base
  class NoSpaceError < StandardError; end

  before_save { self.email = email.downcase }
  has_many :archives, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  has_secure_token
  validates :password, length: { minimum: 8 }, if: -> { password.present? }

  def current_archive
    archives.order(version_number: :desc).first
  end

  def total_archive_size
    ActiveStorage::Blob.joins(:attachments)
                       .where(active_storage_attachments: { record_type: "Archive", record_id: archives.select(:id) })
                       .sum(:byte_size)
  end

  def add_file(new_file)
    raise NoSpaceError.new "No space left" unless has_space?

    Archive.transaction do
      if archives.count >= Rails.configuration.max_archive_count
        archives.order(version_number: :asc).first.destroy
      end

      latest_version = archives.maximum(:version_number) || 0
      archive = archives.new(version_number: latest_version + 1)
      archive.file.attach(new_file)
      archive.save!
      archive
    end
  end

  private

  def has_space?
    total_archive_size < Rails.configuration.maximum_storage
  end
end
