class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_signed_in?
  before_action do
    if params[:token]
      current_user
      flash.now[:notice] = 'Du bist per Cookie angemeldet. Bookmarke die aktuelle Seite um später hierher zurückzukommen'
    end
  end

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

  def require_login
    if !user_signed_in?
      redirect_to root_path, notice: 'Bitte lade erst eine Podcast-Datei hoch.'
    end
  end
end
