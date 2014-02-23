class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def show
  end

  def new
    @tag = Tag.new
    authorize! :create, @tag
  end

  def create
    @tag = Tag.new tag_params
    authorize! :create, @tag

    if @tag.save
      redirect_to @tag, flash: { success: 'Tag créé' }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    authorize! :update, @tag

    if @tag.update tag_params
      redirect_to @tag, flash: { success: 'Tag mis à jour' }
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @tag

    @tag.destroy
    redirect_to new_tag_path, flash: { success: 'Tag supprimé' }
  end

private

  def set_tag
    @tag = Tag.friendly.find params[:id]
  end

  def tag_params
    params.require(:tag).permit(:title)
  end
end
