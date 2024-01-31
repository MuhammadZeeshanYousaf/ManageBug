class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  validates :name, presence: true, length: { minimum: 3 }
  has_one_attached :image
  validates :image, presence: true
  validates :creator_id, presence: true
  has_many :bugs
end
