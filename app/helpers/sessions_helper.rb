module SessionsHelper
	
	def log_in(user)
		session[:user_id] = user.id # Rails session method here encrypts id. This is not params hash
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	# we write like this so to save as an instance variable so no need to hit database every time we need the current user
	def current_user
		if (user_id = session[:user_id])
		  @current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
		  user = User.find_by(id: user_id)
		  if user && user.authenticated?(:remember, cookies[:remember_token])
		    log_in user
		    @current_user = user
		  end
		end
	end

	def current_user?(user)
		user == current_user
	end

	def logged_in?
		!current_user.nil?
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url) # if not delete, fwd to this on every login
	end

	def store_location # store the url of the requested back for friendly forwarding
		session[:fowarding_url] = request.url if request.get? # only if get request. see 9.2.3
	end
end