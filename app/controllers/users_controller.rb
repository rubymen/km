class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.friendly.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      redirect_to @user, as: :user, flash: { success: 'Utilisateur ajoute avec succes' }
    else
      render 'new'
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    @user = User.friendly.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to @user, as: :user, flash: { success: 'Utilisateur modifie avec succes' }
    else
      render 'edit'
    end
  end

  def delete
    User.find(params[:id]).destroy
    redirect_to new_user_path
  end

private

  def user_params
    params.require(:user).permit(:avatar, :birthdate, :country_code, :email, :firstname, :lastname, :password, :password_confirmation, :phone, :street, :town, :type)
  end
end
