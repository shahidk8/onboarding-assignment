class UsersController < ApplicationController

  before_action :redirect_if_signed_in?, :only => [:new]  
    def index
      @users = User.all
    end
  
    def new
      @user = User.new
    end
  
    def create
      name = params[:user][:name]
      email = params[:user][:email]
      password = params[:user][:password]
      @user = User.new({:name => name, :email => email, :password => password})
      if @user.save
        session[:user_id] = @user.id
        flash[:notice]="Sucessfully signed up..."
        redirect_to root_url
      else
        flash[:notice] = "Error signing up"
        render "new"
      end
    end
  
    def destroy
      if User.delete(params[:id]) != 0
        flash[:notice]="User Deleted"
      else
        flash[:notice]="No Such User"
      end
      redirect_to users_path
    end

    def edit
      @user = User.find(params[:id])
    end

    def update
      @user = User.find(params[:id]) # Find the user to update
      puts "user_params :"+params.to_s
      if @user.update(user_params) # Update the user's attributes
        flash[:notice]= "Successfully updated"
        redirect_to @user
      else
        flash[:notice]= "Error while updating"
        render :edit
      end
    end
  
  end
  

  def user_params
    params.require(:user).permit(:name, :email,:password,:role)
  end