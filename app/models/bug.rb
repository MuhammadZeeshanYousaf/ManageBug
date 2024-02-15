class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :user # @todo - it must be developer like the following
  belongs_to :developer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :creator, class_name: 'User'

  enum status: {
    pending: 0,
    started: 1,
    completed: 2,
    resolved: 3,
  }
  enum bug_type: {
    bug: 0,
    feature: 1,
  }

  validates :title, :status, :bug_type, :developer, :project_id, :deadline, presence: true
  validates_uniqueness_of :title, scope: :project_id
  validate :deadline_cannot_be_in_the_past
  validate :assignee_is_developer
  validate :deadline_cannot_be_in_the_past, on: :create
  mount_uploader :screenshot, ImageUploader
  default_scope -> { order(created_at: :asc) }

  private
    def deadline_cannot_be_in_the_past
      if deadline.present? && deadline < Date.today
        errors.add(:deadline, 'cannot be in the past')
      end
    end

    def assignee_is_developer
      errors.add(:developer, 'must have role developer') unless developer&.developer?
    end

end
