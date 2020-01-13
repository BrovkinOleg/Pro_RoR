class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
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
      gon.question_id = @question.id
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:notice] = "You must fill all fields."
      render :new
    end
  end

  def update
    authorize! :update, question
    @question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    @question.destroy
    redirect_to questions_path, notice: 'You question successfully deleted.'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions_channel', @question.to_json)
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: %i[id name url _destroy],
                                     profit_attributes: %i[name image _destroy])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
