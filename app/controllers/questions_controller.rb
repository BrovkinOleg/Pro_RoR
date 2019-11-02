class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
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
