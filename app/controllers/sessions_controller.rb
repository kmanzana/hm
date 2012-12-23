class SessionsController < ApplicationController
  def new
  end

  def create
    parent = Parent.find_by_email(params[:session][:email].downcase)
    if parent && parent.authenticate(params[:session][:password])
      sign_in parent
      redirect_to parent
    else
      flash.now[:error] = 'Invalid email/password combination' 
      render 'new'
    end
  end

  def destroy
  end
end
