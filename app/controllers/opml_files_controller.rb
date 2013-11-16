class OpmlFilesController < ApplicationController
  before_action :set_opml_file, only: [:show, :edit, :update, :destroy]

  # GET /opml_files
  def index
    @opml_files = OpmlFile.all
  end

  # GET /opml_files/1
  def show
  end

  # GET /opml_files/new
  def new
    @opml_file = OpmlFile.new
  end

  # GET /opml_files/1/edit
  def edit
  end

  # POST /opml_files
  def create
    @opml_file = OpmlFile.new(opml_file_params)

    if @opml_file.save
      redirect_to @opml_file, notice: 'Opml file was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /opml_files/1
  def update
    if @opml_file.update(opml_file_params)
      redirect_to @opml_file, notice: 'Opml file was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /opml_files/1
  def destroy
    @opml_file.destroy
    redirect_to opml_files_url, notice: 'Opml file was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_opml_file
      @opml_file = OpmlFile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def opml_file_params
      params.require(:opml_file).permit(:source, :owner_id)
    end
end
