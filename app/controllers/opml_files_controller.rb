class OpmlFilesController < ApplicationController
  before_action :require_login, only: :destroy
  load_and_authorize_resource except: [:create]

  def create
    file = params[:file]
    import = OpmlImport.new(file, current_user(true))
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
    @sources = @opml_file.sources.order('title')
    respond_to do |f|
      f.html
      f.xml {
        if params[:download]
          stream = render_to_string :show
          send_data(stream, :type=>"text/xml",:filename => "podcast-opml.xml")
        end
      }
    end
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
