class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit]

  def index
    @questions = Question.all
  end

  def show; end

  def edit; end

  def new
    @question = Question.new(title: '123', body: '123')
  end

  def create
    @question = Question.new
    if @question
      render new_question_path
    else
      render edit_question_path
    end
  end
end

  private

  def load_question
    @question = Question.find(params[:id])
  end
