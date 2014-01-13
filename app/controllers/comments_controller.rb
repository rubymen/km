class CommentsController < ApplicationController
  before_action :set_comment, only: :destroy
  before_action :set_document

  def index
    @comments = @document.comments
  end

  def new
    @comment = @document.comments.build
  end

  def create
    @comment = @document.comments.build comment_params
    @comment.user = current_user

    if @comment.save
      redirect_to document_comments_path(@document), flash: { success: t('validation.create', model: @comment.class.model_name.human.downcase) }
    else
      render 'new'
    end
  end

  def destroy
    @comment.destroy
    redirect_to document_comments_path(@document), flash: { success: t('validation.destroy', model: @comment.class.model_name.human.downcase) }
  end

private

  def set_comment
    @comment = Comment.find params[:id]
  end

  def set_document
    @document = Document.friendly.find(params[:document_id]) || Document.find(params[:document_id])
  end

  def comment_params
    params.require(:comment).permit(:comment_id, :content, :title)
  end
end
