class AttachmentsController < ApplicationController
  before_action :set_attachment, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @attachment = Attachment.new
  end

  def create
    @attachment = Attachment.new attachment_params

    if @attachment.save
      redirect_to @attachment, flash: { success: 'Pièce jointe créée' }
    else
      render new
    end
  end

  def edit
  end

  def update
    if @attachment.update attachment_params
      redirect_to @attachment, flash: { success: 'Pièce jointe modifiée' }
    else
      render 'edit'
    end
  end

  def destroy
    @attachment.destroy
    redirect_to new_attachment_path, flash: { success: 'Pièce jointe supprimée' }
  end

private

  def set_attachment
    @attachment = Attachment.find params[:id]
  end

  def attachment_params
    params.require(:attachment).permit(:path)
  end
end
