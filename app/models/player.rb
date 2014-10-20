class Player < ActiveRecord::Base

	require 'csv'
	
	belongs_to :user
	default_scope -> { order('value DESC') }

	validates :name, :presence => true, uniqueness: { case_sensitive: false, :scope => :user_id } # only need uniqueness for each player that belongs to a user
	validates :value, :presence => true, :numericality => true
	validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

	def self.import(file, user) # need to pass in user so we can use player build
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			@player = user.players.build(row.to_hash)
			@player.save
#			parameters = ActionController::Parameters.new(row.to_hash)
#			user.players.build(parameters.permit(:name, :value, :price))
		end
	end

	# buld a different roo spreadsheet based on file extension
	def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
	  when ".csv" then Roo::CSV.new(file.path)
	  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
	  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
	  else raise "Unknown file type: #{file.original_filename}"
  	end
	end

end
