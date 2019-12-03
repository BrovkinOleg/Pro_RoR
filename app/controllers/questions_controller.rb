class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def edit; end

  def new
    @question = Question.new
    @question.links.new
    @profit = @question.build_profit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:notice] = "You must fill all fields."
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.author?(@question)
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      flash[:notice] = 'You question successfully deleted.'
    else
      flash[:notice] = 'You can not delete this question.'
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     profit_attributes: %i[name image _destroy])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
