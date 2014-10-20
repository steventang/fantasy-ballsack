class KnapsackController < ApplicationController

  def calculate
  	@user = current_user
  	@player = Player.new # we're going to render home page, so need to pass in a @player for the form
  	
  	if @user.players.any?		
  		if !@user.budget.nil? && !@user.team_size.nil?
  			solve_knapsack
  		else
  			flash.now[:warning] = "You must first specify a budget and team size"
  		end
  	else
  		flash.now[:warning] = "No players added!"	
  	end
  	
  	render 'static_pages/home'
  end

end
