class SessionsController < ApplicationController
    def new
        @title = "Sign in"
    end
    
    def create
        user = User.authenticate(params[:session][:name],
                                 params[:session][:password])
        #     if user.nil?
        #    flash.now[:error] = "Invalid name/password combination or you don't have an access."
        #     @title = "Sign in"
        #   render 'new'
        #   else
        #    sign_in user
        #   redirect_back_or user
        # end
        respond_to do |format|
            if user
                format.html do 
                    #  reset_session
                    session[:user_id] = user.id
                    sign_in user
                    redirect_back_or user
                end
                format.any(:xml, :json) { head :ok }
                else
                format.html do 
                    flash.now[:error] = "Invalid login or password."
                    render :action => :new 
                end
                format.any(:xml, :json) { request_http_basic_authentication 'Web Password' }
            end
        end
    end
    
    def destroy
        session[:user_id] = nil
        #   flash[:notice] = "You've been logged out."
        sign_out
        redirect_to root_path
    end

end
