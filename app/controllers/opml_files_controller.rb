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

  def add_source
    source = Source.find(params[:source_id])
    @opml_file.sources << source unless @opml_file.sources.where('sources.id = ?', params[:source_id]).count > 0
    redirect_back_or_dashboard notice: "Quelle #{source.title} hinzugefügt"
  end

  def remove_source
    source = Source.find(params[:source_id])
    @opml_file.sources = @opml_file.sources - [source]
    redirect_back_or_dashboard notice: "Quelle #{source.title} entfernt"
  end

end
