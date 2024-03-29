class UsersController < ApplicationController
    before_filter :authenticate #, :only => [:edit, :update]
    #  before_filter :correct_user, :only => [:edit, :update]
    before_filter :admin_user,   :only => [:destroy, :new, :create, :edit, :update]
    def index
        @title = "All users"
        @users = User.paginate(:page => params[:page])
    end
    def show
        @user = User.find(params[:id])
        @title = @user.name
    end
  def new
      @user = User.new
      @title = "New user"
  end
    def create
        @user = User.new(params[:user])
        if @user.save
            session[:user_id] = @user.id #???
            # sign_in @user
            #  flash[:success] = "Welcome to the Courier Tracking App!"
            redirect_to users_path
            else
            @title = "New user"
            render 'new'
        end
    end
    def edit
        @user = User.find(params[:id])
        @title = "Edit user"
    end
    def update
        @user = User.find(params[:id])
        if @user.update_attributes(params[:user])
            flash[:success] = "Profile updated."
            redirect_to @user
            else
            @title = "Edit user"
            render 'edit'
        end
    end
    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."
        redirect_to users_path
    end
    private
    
    def authenticate
          deny_access unless signed_in?
        #  authenticate_or_request_with_http_basic do |name, password|
        #   name == "foot" && password == "bar"
        #  end
    end
    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
        redirect_to(root_path) unless current_user.admin?
    end
end
