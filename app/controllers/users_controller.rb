class UsersController < ApplicationController
  def edit ;end

  def update
    current_user.attributes = user_params
    if current_user.save
      flash[:notice] = "Data updated successfully"
      redirect_to edit_user_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone_number, :otp_required_for_login, :two_factor_auth_method)
  end
end