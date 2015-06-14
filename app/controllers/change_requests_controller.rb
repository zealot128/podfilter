class ChangeRequestsController < ApplicationController
  before_filter :require_login, except: [:apply, :apply_submit]

  def new
    type = ChangeRequest.types.find{|i| i == params[:type]}
    @change_request = type.constantize.new
    @change_request.prefill(params)
  end

  def create
    type = ChangeRequest.types.find{|i| i == params[:type]}
    @change_request = type.constantize.new
    @change_request.assign_attributes(@change_request.class.permit(params))
    @change_request.owner = current_user
    if @change_request.save
      ChangeRequestMailer.cr(@change_request).deliver
      redirect_to '/', notice: 'Änderungsantrag an Moderator versendet. Vielen Dank für die Einsendung'
    else
      render :new
    end
  end

  def apply
    @title = 'Change Request anwenden'
    @change_request = ChangeRequest.where(token: params[:token]).first!
  end

  def apply_submit
    @change_request = ChangeRequest.where(token: params[:token]).first!
    @change_request.assign_attributes(@change_request.class.permit(params))
    if @change_request.save
      @change_request.apply!
      redirect_to '/', notice: 'Änderung abgeschlossen.'
    else
      render :apply
    end
  end

  def destroy
    @change_request = ChangeRequest.where(token: params[:id]).first!
    @change_request.destroy
    redirect_to :back, notice: 'Änderung gelöscht'
  end
end
