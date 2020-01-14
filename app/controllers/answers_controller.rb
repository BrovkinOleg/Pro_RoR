class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:edit, :update, :destroy, :best_answer]
  before_action :load_question
  after_action :publish_answer, only: :create

  authorize_resource

  def new
    @answer = Answer.new
  end

  def create
    @answer = current_user.answers.create(answer_params.merge(question: @question))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def edit; end

  def destroy
    @answer.destroy
  end

  def best_answer
    @answer.best_answer!
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions/#{@answer.question_id}/answers", @answer.to_json)
  end

  def load_question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : load_answer.question
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: %i[id name url _destroy])
  end
end
