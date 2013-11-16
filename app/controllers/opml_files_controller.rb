class OpmlFilesController < ApplicationController
  def create
    file = params[:file]
    import = OpmlImport.new(file, current_user)
    opml_file = import.run!
    respond_to do |format|
      format.json {
        render json: {
          url: opml_file_path(opml_file, token: current_user.token),
          log: import.log
        }
      }
    end
  end

  def show
    @opml_file = OpmlFile.find(params[:id])
  end
end
