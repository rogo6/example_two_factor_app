class UsersController < ApplicationController
  def edit
    @form = Users::UpdateForm.new(current_user)
  end

  def update
    @form = Users::UpdateForm.new(current_user)
    if @form.save_form(user_params)
      flash[:notice] = "Data updated successfully"
      redirect_to edit_user_path(current_user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :phone_number, :two_factor_auth_method)
  end
end