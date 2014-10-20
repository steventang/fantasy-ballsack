class User < ActiveRecord::Base

	attr_accessor :remember_token

	has_many :players, :dependent => :destroy

	validates :budget, :numericality => { :greater_than => 0 }, :allow_blank => true
	validates :team_size, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true


	def self.new_token # the self. makes this a class method
		SecureRandom.urlsafe_base64
	end

	def remember #8.4.1
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
		# use update_attribute to bypass validations bc we may not have password
	end

	def forget
		update_attribute(:remember_digest, nil)
	end

	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated?(attribute, token) #meta-programming that allows this to authenticate any token 10.1.3
    digest = send("#{attribute}_digest")
    BCrypt::Password.new(digest).is_password?(token)
  end

end
