class NewAnswerMailer < ApplicationMailer

  def inform(answer, user)
    @answer = answer
    @question = answer.question

    mail to: user.email,
         subject: "User #{user.email} just answered your question: #{@question.title}"
  end
end
