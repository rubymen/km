class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = Document.all
  end

  def show
  end

  def new
    @document = Document.new
    attachment = @document.attachments.build
  end

  def create
    @document = Document.new document_params

    if @document.save
      redirect_to @document, flash: { success: 'Document créé' }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @document.update document_params
      redirect_to @document, flash: { success: 'Document mis à jour' }
    else
      render 'edit'
    end
  end

  def destroy
    @document.destroy
    redirect_to new_document_path, flash: { success: 'Document supprimé' }
  end

private

  def set_document
    @document = Document.friendly.find params[:id]
  end

  def document_params
    params.require(:document).permit(:content, :description, :title, attachments_attributes: :path)
  end
end
