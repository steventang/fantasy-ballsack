class Player < ActiveRecord::Base

	validates :name, :presence => true
	validates :value, :presence => true
	validates :price, :presence => true

end
