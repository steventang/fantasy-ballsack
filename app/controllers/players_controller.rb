class PlayersController < ApplicationController
  def new
  	@user = current_user
  	@player = @user.player.new
  end

  def create
  	@user = current_user
  	@player = @user.players.build(player_params)
  	if @player.save
  		flash[:success] = "#{@player.name} has been added"
  		redirect_to root_url
  	else
  		flash[:warning] = "Fill in every field for your player. Value must be a number. Price must be a positive number."
  		redirect_to root_url
  	end
  end

  def destroy
  	current_user.players.find(params[:id]).destroy
  	redirect_to root_url
  end

  def show
  	@player = Player.find(params[:id])
  end

  def import
  	puts "we reach import action"
  	Player.import(params[:file], current_user)
  	flash[:success] = "Players uploaded"
  	redirect_to root_url
  end

  private

  	def player_params
  		params.require(:player).permit(:name, :value, :price)
  	end
end
