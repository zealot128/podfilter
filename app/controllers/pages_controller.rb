class PagesController < ApplicationController
  before_action :require_login, only: :dashboard
  def index
  end

  def impress
  end

  def dashboard
    @owner = current_user
    @recommended_sources = @owner.recommended_sources.order('weight desc').
      select('sources.*, weight')

  end
end
