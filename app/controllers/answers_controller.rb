class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = current_user.answers.new(answer_params.merge(question: @question))
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    else
      flash[:notice] = 'Answer field can not be blank.'
    end
    render 'questions/show'
  end

  def edit; end

  def destroy
    @answer.destroy if current_user.author?(@answer)
    redirect_to @answer.question, notice: 'Answer successfully deleted.'
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
