class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Неверное сочетание email и пароля'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to store_url
  end
end
