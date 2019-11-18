class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy, :best_answer]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def update
    @answer.update(answer_params) if current_user.author?(@answer)
    @question = @answer.question
  end

  def edit; end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    render 'answers/destroy.js.erb'
  end

  def best_answer
    @answer.best_answer! if current_user.author?(@answer.question)
  end

  private

  def load_question
    @question ||= Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
