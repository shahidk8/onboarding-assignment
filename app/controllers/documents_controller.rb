# DocumentsController
require "json"
class DocumentsController < ApplicationController

  before_action :require_user, :only => [:new, :index, :destroy, :show, :update]
  
    def index
        @documents = current_user.documents
    end
  
    def new
      @document = Document.new
    end
  
    def create
      description = params[:document][:description]
      temp = params[:document][:doc]

      json_temp = JSON.dump({:original_filename => temp.original_filename, :tempfile => temp.tempfile, :path => temp.path})
      @document = current_user.documents.build(:path => json_temp, :description => description)
      if @document.save
        flash[:notice]="File Uploaded Successfully!"
        redirect_to documents_path
      else
        flash[:notice]="Error uploading files"
        render new_document_path
      end
    end
  
    def show
      if document = Document.find_by_id(params[:id])
        path = document.path
        File.open(path, "r") do |f|
          send_data f.read, :filename => document.name
        end
      else
        flash[:notice]="no such file"
        redirect_to root_url
      end
    end
    
    def update_column
      @document = Document.find(params[:id])
      if @document
        if @document.update_attribute(:shared, params[:column_name]) && @document.user_id == session[:user_id]
          true
        end
      end
    end
  
    def destroy
      @document = Document.find(params[:id])
      if @document
        if @document.user_id == session[:user_id]
          @document.destroy
          flash[:notice] = "File deleted"
        else
          flash[:notice] = "You do not own this file"
        end
      else
        flash[:notice] = "No such file"
      end
      redirect_to root_url
    end
  
  def shared_view
    @documents = current_user.documents
    render 'shared/_shared'
  end

end