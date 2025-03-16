class ArchivesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :token_request?
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found

  def index
  end

  def new
    @archive = Archive.new
  end

  def create
    current_user.add_file(params[:archive][:file])
    redirect_to archives_path, notice: "Backup successfully created."
  rescue NoMethodError
    @archive = Archive.new
    flash.now[:danger] = "Please select a file."
    render "new", status: :bad_request
  rescue User::NoSpaceError
    @archive = Archive.new
    flash.now[:danger] = "You have exceeded your account’s usage quota."
    render "new", status: :content_too_large
  end

  def show
    @archive = current_user.archives.find_by!(version_number: params[:id])
  end

  def destroy
    @archive = current_user.archives.find_by!(version_number: params[:id])
    version_number = @archive.version_number
    @archive.destroy!
    redirect_to archives_path, notice: "Backup version #{version_number} deleted."
  end

  def latest
    @archive = current_user.current_archive
    raise ActiveRecord::RecordNotFound unless @archive
    render "show"
  end

  def download
    begin
      @archive = current_user.archives.find_by!(version_number: params[:id])
    rescue ActiveRecord::RecordNotFound
      @archive = current_user.current_archive
    end

    send_data @archive.file.download, filename: "MeritCards.#{@archive.version_number}.bin"
  rescue NoMethodError
    render "404", status: :not_found
  end

  def promote
    @archive = current_user.archives.find_by!(version_number: params[:archive_id])
    @archive.promote!
    render "show"
  rescue RuntimeError => e
    flash.now[:danger] = e
    render "show", status: :bad_request
  end

  def error_not_found
    render "404", status: :not_found
  end
end
