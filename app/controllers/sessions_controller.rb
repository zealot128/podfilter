class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    if current_user
      @owner = current_user
    else
      @owner = Owner.new
    end
    owner = OauthAdapter.run(params[:provider], @owner, auth)
    # Reset the session after successful login, per
    # 2.8 Session Fixation – Countermeasures:
    # http://guides.rubyonrails.org/security.html#session-fixation-countermeasures
    session[:owner_id] = owner.id
    redirect_to dashboard_path, notice: I18n.t('application.signed_in')
  end

  def destroy
    reset_session
    redirect_to root_url, notice: I18n.t('application.signed_out')
  end

end
