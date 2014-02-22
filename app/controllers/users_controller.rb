class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def autocomplete
    render json: User.search(params[:query], fields: [{ lastname: :text_start }], limit: 10)
  end

  def index
    @users = User.to_search params
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to @user, as: :user, flash: { success: t('validation.create', model: @user.class.model_name.human.downcase) }
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to @user, as: :user, flash: { success: t('validation.update', model: @user.class.model_name.human.downcase) }
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to new_user_path, flash: { success: t('validation.destroy', model: @user.class.model_name.human.downcase) }
  end

private

  def set_user
    @user = User.friendly.find params[:id]
  end

  def user_params
    params.require(:user).permit(:avatar, :birthdate, :country_code, :email, :firstname, :lastname, :password, :password_confirmation, :phone, :street, :town, :type)
  end
end
