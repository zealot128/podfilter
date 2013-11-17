class OpmlFilesController < ApplicationController
  before_action :require_login, only: :destroy
  def create
    file = params[:file]
    import = OpmlImport.new(file, current_user)
    import.run!
    SimilarityCalculation.refresh_all
    respond_to do |format|
      format.json {
        render json: {
          url: dashboard_path,
          log: import.log
        }
      }
    end
  end

  def show
    @opml_file = OpmlFile.find(params[:id])
  end

  def destroy
    @opml_file = OpmlFile.find(params[:id])
    if current_user != @opml_file.owner
      redirect_to root_path, notice: 'Du kannst nur deine eigenen OPMLs löschen'
    else
      @opml_file.destroy
      redirect_to dashboard_path, notice: 'Datei gelöscht'
    end
  end
end
