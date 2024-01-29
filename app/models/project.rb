class Project < ApplicationRecord
  has_many :project_users
  has_many :users, through: :project_users
  validates :name, presence: true, length: { minimum: 3 }
end