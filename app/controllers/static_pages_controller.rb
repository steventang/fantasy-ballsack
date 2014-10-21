class StaticPagesController < ApplicationController
  def home
  	@player = Player.new
  	if current_user.nil?
  		user = User.create
  		@user = user
	  	log_in user
	  	remember user
	  else
	  	@user = current_user # set @user so we can edit team size and budget in home view
	  end
  end

  def about
  end
end