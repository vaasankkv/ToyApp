class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'sessions/new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  #  def redirect_back_or(default)
  # #   redirect_to(session[:forwarding_url] || default)
  # #   session.delete(:forwarding_url)
  # # end
  # # def store_location
  # #   session[:forwarding_url] = request.url if request.get?
  #  end
end
