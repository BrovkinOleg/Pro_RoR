class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    authorize! :destroy, @attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
    @attachment.purge if current_user.author?(@attachment.record)
  end
end
