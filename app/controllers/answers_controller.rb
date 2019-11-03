class AnswersController < ApplicationController

  def new
    @answer = Answer.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
