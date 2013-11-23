class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_signed_in?
  before_action do
    if params[:token]
      current_user
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  protected

    # NOTE Cancan 4 -> strong params
  before_filter do
    method = "permitted_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  def current_user(create=false)
    owner = if params[:token]
      Owner.where(token: params[:token]).first!
    elsif session[:owner_id]
      Owner.find(session[:owner_id])
    elsif create
      Owner.create
    end
    return nil if owner.nil?
    session[:owner_id] = owner.id
    owner
  rescue Exception
    session[:owner_id] = nil
  end

  def user_signed_in?
    return true if session[:owner_id] && current_user
  end

  def redirect_back_or_dashboard(*args)
    if request.env["HTTP_REFERER"]
      redirect_to :back, *args
    else
      redirect_to '/dashboard', *args
    end
  end

  def require_login
    if !user_signed_in?
      redirect_to root_path, notice: 'Bitte lade erst eine Podcast-Datei hoch.'
    end
  end
end
