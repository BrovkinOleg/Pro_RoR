class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource, only: :create
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def load_resource
    parameter = params[:commentable].singularize + '_id'
    @commentable = params[:commentable].classify.constantize.find(params[parameter])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    question_id = params['question_id'] || @comment.commentable.question_id

    ActionCable.server.broadcast("questions/#{question_id}/comments", @comment.to_json)
  end
end
