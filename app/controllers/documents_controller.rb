class DocumentsController < ApplicationController
  require 'will_paginate/array'
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @search     = Document.search params
    @documents  = @search.results.paginate(page: params[:page], per_page: 20)
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
    params.require(:document).permit(:content, :description, :title, attachments_attributes: :path)
  end
end
