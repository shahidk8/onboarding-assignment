# UsersController
class UsersController < ApplicationController

  before_action :redirect_if_signed_in?, :only => [:new]  

    def new
      @user = User.new
    end
  
    def create
      name = params[:user][:name]
      email = params[:user][:email]
      password = params[:user][:password]
      user_name = params[:user][:user_name]
      @user = User.new({:name => name, :email => email, :password => password, :user_name => user_name})
      if @user.save
        session[:user_id] = @user.id
        flash[:notice]="Sucessfully signed up..."
        redirect_to root_url
      else
        flash[:notice] = "Error signing up"
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id]) # Find the user to update
      if @user.update(user_params) # Update the user's attributes
        flash[:notice]= "Successfully updated"
        redirect_to @user
      else
        flash[:notice]= "Error while updating"
        render :edit
      end
    end
    def user_params
      params.require(:user).permit(:name, :email)
    end

end
  

