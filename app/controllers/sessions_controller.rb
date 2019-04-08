class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate(params[:session][:password])
    else
      flash[:danger] = t ".invalid_email"
      render :new
    end
  end

  def destroy; end
end
