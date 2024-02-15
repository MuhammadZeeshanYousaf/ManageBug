class HardJob
  include Sidekiq::Job

  def perform(users)
    users.each do |user|
      UserMailer.assigning_email(user).deliver_now
    end
  end
end
