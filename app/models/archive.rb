class Archive < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :version_number, presence: true, numericality: { greater_than_or_equal_to: 1 }

  def promote!
    if version_number == user.current_archive.version_number
      raise RuntimeError.new "Cannot promote backup if it is already the latest one."
    end

    latest_version = user.archives.maximum(:version_number) || 0
    update! version_number: latest_version + 1
  end
end
