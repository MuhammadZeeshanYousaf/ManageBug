class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_one_attached :image
  has_many :bugs
  belongs_to :creator, class_name: 'User'

  validates :name, presence: true, length: { minimum: 3 }
  validates :image, presence: true
  validates :creator_id, presence: true
end
