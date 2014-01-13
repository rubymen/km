class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    search = params[:elastic].try(:[], :search)

    @documents = Document.search page: (params[:page] || 1), per_page: 20 do
      if search.blank?
        query { all } if search.blank?
      else
        query { string "*#{search}*" }
        sort { by :title, 'desc' }
        highlight :title, :description, options: { tag: "<span class='highlight'>" }
      end
    end
  end

  def show
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new document_params

    if @document.save
      redirect_to @document, flash: { success: t('validation.create', model: @document.class.model_name.human.downcase) }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @document.update document_params
      redirect_to @document, flash: { success: t('validation.update', model: @document.class.model_name.human.downcase) }
    else
      render 'edit'
    end
  end

  def destroy
    @document.destroy
    redirect_to new_document_path, flash: { success: t('validation.destroy', model: @document.class.model_name.human.downcase) }
  end

private

  def set_document
    @document = Document.friendly.find params[:id]
  end

  def document_params
    params.require(:document).permit(:content, :description, :title)
  end
end
