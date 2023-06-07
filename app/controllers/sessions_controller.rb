# SessionsController
class SessionsController < ApplicationController

  before_action :redirect_if_signed_in?, :only => [:new]

    def new
    end

    def create
      user_name = params[:session][:user_name]
      email = params[:session][:email]
      password = params[:session][:password]
      user = User.find_by_user_name(user_name)
      if user && user.authenticate(password)
        session[:user_id] = user.id
        redirect_to root_url
      else
        flash[:notice] = "Incorrect Credentials"
        redirect_to login_url
      end
    end

  def destroy
    session[:user_id]=nil
    redirect_to root_url
  end
  
end