class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: {
    manager: 0,
    developer: 1,
    QA: 2,
  }
  validates :role, presence: true
  validates :name, presence: true, length: { minimum: 3, maximum: 30 }
  validates :phone_number, presence: true
  has_many :project_users, dependent: :destroy
  has_many :project, through: :project_users
  has_many :bugs

  def get_user_project
    case role
    when "manager"
      Project.where(creator_id: id)
    when "developer"
      project
    when "QA"
      project
    else
      []
    end
  end
end
