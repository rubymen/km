class DocumentsController < ApplicationController
  before_action :set_document, only: [:change_version, :state, :show, :edit, :update, :destroy]

  def autocomplete
    render json: Document.search(params[:query], fields: [{ title: :text_start }], limit: 10)
  end

  def change_version
    @document.destroy
    @document = PaperTrail::Version.find(params[:version]).reify
    @document.save
    redirect_to @document, flash: { success: t('validation.reify', model: @document.class.model_name.human.downcase) }
  end

  def state
    PaperTrail.enabled = false

    @document.try params[:state]

    PaperTrail.enabled = true
    redirect_to @document
  end

  def index
    @documents = Document.to_search params
  end

  def show
    impressionist @document, "", unique: [:impressionable_type, :session_hash]
    Document.reindex
  end

  def new
    @document = Document.new
    authorize! :create, @document
  end

  def create
    @document = current_user.documents.build document_params
    @document.users << current_user
    authorize! :create, @document

    if @document.save
      redirect_to @document, flash: { success: t('validation.create', model: @document.class.model_name.human.downcase) }
    else
      render 'new'
    end
  end

  def edit
    authorize! :update, @document

    unless @document.users.include? current_user
      @document.users << current_user
    end
  end

  def update
    authorize! :update, @document

    if @document.update document_params
      redirect_to @document, flash: { success: t('validation.update', model: @document.class.model_name.human.downcase) }
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @document

    @document.destroy
    redirect_to new_document_path, flash: { success: t('validation.destroy', model: @document.class.model_name.human.downcase) }
  end

private

  def set_document
    @document = Document.friendly.find params[:id]
  end

  def document_params
    params.require(:document).permit(:content, :description, :title, attachments_attributes: [:id, :path, :_destroy], user_ids: [], tag_ids: [])
  end
end
