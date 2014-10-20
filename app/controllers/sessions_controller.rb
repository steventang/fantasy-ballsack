class SessionsController < ApplicationController
  def new
  end

  def destroy
  	forget(current_user)
    session.delete(:user_id)
    @current_user = nil
    redirect_to root_url
  end
end
