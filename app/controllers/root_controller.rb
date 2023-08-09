class RootController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    redirect_to secret_index_path if user_signed_in?
  end
end
