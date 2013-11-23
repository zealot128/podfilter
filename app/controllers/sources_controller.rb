class SourcesController < ApplicationController
  load_and_authorize_resource
  def index
    sql = Source.page(params[:page]).per(30)
    if params[:q]
      sql = sql.search(params[:q])
    end
    if params[:fin]
      sql = sql.where(active: [true, nil])
    end
    if params[:foff]
      sql = sql.where(offline: [nil, false])
    end
    sql = sql.roots

    @sources = sql
  end

  def show
  end

end
