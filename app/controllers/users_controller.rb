class UsersController < ApplicationController
  before_action :authenticate

  def show
  end

  def edit
  end

  def update
    @email = params.require(:email).downcase
    @current_password = params[:current_password]
    @password = params[:password]

    if current_user.authenticate(@current_password)
      current_user.update! password: @password, password_confirmation: @password,
                           email: @email
      flash.now[:notice] = "E-mail address/password updated successfully."
      render "edit"
    else
      flash.now[:danger] = "Current password does not match."
      render "edit", status: :bad_request
    end
  rescue ActionController::ParameterMissing
    flash.now[:danger] = "Please enter an e-mail address/a password."
    render "edit", status: :bad_request
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:danger] = e
    render "edit", status: :bad_request
  end

  def destroy
    if params[:confirmation] != "1"
      flash.now[:danger] = "Click on the checkbox to confirm deleting your account."
      render "delete_confirmation"
      return
    end

    current_user.destroy!
    log_out
    redirect_to login_path, notice: "Account successfully deleted."
  end

  def delete_confirmation
  end
end
