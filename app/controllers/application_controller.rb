class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_signed_in?

  protected
  def current_user
    owner = if params[:token]
      Owner.where(token: params[:token]).first!
    elsif session[:owner_id]
      Owner.find(session[:owner_id])
    else
      Owner.create
    end
    session[:owner_id] = owner.id
    owner
  rescue Exception
    session[:owner_id] = nil
    Owner.create
  end

  def user_signed_in?
    return true if session[:owner_id] && current_user
  end
end
