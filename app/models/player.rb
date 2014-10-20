class Player < ActiveRecord::Base

	require 'csv'
	require 'iconv'
	
	belongs_to :user
	default_scope -> { order('value DESC') }

	validates :name, :presence => true, uniqueness: { case_sensitive: false, :scope => :user_id }
	validates :value, :presence => true, :numericality => true
	validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

	def self.import(file, user)
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		CSV.foreach(file.path, :headers => true) do |row|
			@player = user.players.build(row.to_hash)
			@player.save
#			parameters = ActionController::Parameters.new(row.to_hash)
#			user.players.build(parameters.permit(:name, :value, :price))
		end
	end

end
