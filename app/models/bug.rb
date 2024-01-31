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
end
