class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :user
  enum status: {
    pending: 0,
    in_progress: 1,
    closed: 2,
  }
  enum type: {
    bug: 0,
    feature: 1,
  }
  has_one_attached :image
  validates :image, presence: true
  validates :title, presence: :true
  validates_uniqueness_of :title, scope: :project_id
  validates :project_id, presence: true
  validate :deadline_cannot_be_in_the_past

  def deadline_cannot_be_in_the_past
    if deadline.present? && deadline < Date.today
      errors.add(:deadline, "can't be in the past")
    end
  end
end
