class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_one_attached :image
  has_many :bugs
  belongs_to :creator, class_name: 'User'

  validates :name, presence: true, length: { minimum: 3 }
  validates :image, presence: true
  validates :creator_id, presence: true
  validate :creator_not_qa_or_dev


  private
    def creator_not_qa_or_dev
      errors.add(:creator, 'cannot be QA') if creator&.QA?
      errors.add(:creator, 'cannot be developer') if creator&.developer?
    end



end
