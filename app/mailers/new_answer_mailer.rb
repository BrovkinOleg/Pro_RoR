class NewAnswerMailer < ApplicationMailer
  def send_mail(answer, user)
    @answer = answer
    @question = answer.question

    mail to: user.email,
         subject: "User #{user.email} just answered your question: #{@question.title}"
  end
end
