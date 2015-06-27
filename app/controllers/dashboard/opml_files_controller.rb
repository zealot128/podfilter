class Dashboard::OpmlFilesController < ApplicationController
  before_action :require_login

  def new
    @opml_file = OpmlFile.new
  end

  def create
    @opml_file = OpmlFile.new(permitted_params)
    @opml_file.owner = current_user
    if @opml_file.save
      redirect_to '/dashboard', notice: t('opml_files.created')
    else
      render :new
    end
  end

  def edit
    @opml_file = current_user.opml_files.find(params[:id])
  end

  def update
    @opml_file = current_user.opml_files.find(params[:id])
    if @opml_file.update(permitted_params)
      redirect_to @opml_file, notice: t('opml_files.updated')
    else
      render :edit
    end
  end

  def destroy
    @opml_file = current_user.opml_files.find(params[:id])
    @opml_file.destroy
    redirect_to '/dashboard', notice: t('opml_files.deleted')
  end


  private

  def permitted_params
    params.require(:opml_file).permit(:name)
  end

end
