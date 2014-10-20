class UserController < ApplicationController
	
  def update
  	@user = current_user
  	if @user.update_attributes(user_params)
  		#draft_parameter = params[:draft_parameter] # we passed in a hidden field tag to get this
      flash[:success] = "Draft parameters updated"
      redirect_to root_url
    else
    	@player = Player.new
    	flash[:warning] = "Budget must be postive number. Team size must be positive integer"
      redirect_to root_url
    end
  end

  private
	  def user_params
	  	params.require(:user).permit(:budget, :team_size)
  	end

end
