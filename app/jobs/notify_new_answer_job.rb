class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each do |subscriber|
      NewAnswerMailer.send_mail(answer, subscriber.user).deliver_later unless subscriber.user.author?(answer)
    end
  end
end
