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
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      flash[:notice] = 'Answer field can not be blank.'
      render @question.answers
    end
  end

  def edit; end

  # def update
  #   if current_user.author?(@answer)
  #     if @answer.update(answer_params)
  #       redirect_to @answer.question
  #     else
  #       render :edit
  #     end
  #   end
  # end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:notice] = 'You can not delete this question.'
    end
    redirect_to @answer.question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
