class DocumentsController < ApplicationController
  before_action :set_document, only: [:change_version, :state, :show, :edit, :update, :destroy, :zip]

  def autocomplete
    render json: Document.search(params[:query], fields: [{ title: :text_start }], limit: 10)
  end

  def change_version
    authorize! :update, @document

    tags  = @document.tags.each { |t| t }
    users = @document.users.each { |u| u }

    @document.destroy
    @document = PaperTrail::Version.find(params[:version]).reify
    @document.tags << tags
    @document.users << users
    @document.save
    redirect_to @document, flash: { success: t('validation.reify', model: @document.class.model_name.human.downcase) }
  end

  def state
    authorize! :state, @document

    PaperTrail.enabled = false
    @document.try params[:state]
    PaperTrail.enabled = true
    redirect_to @document
  end

  def index
    @documents = Document.to_search params
  end

  def show
    authorize! :read, @document

    impressionist @document, '', unique: [:impressionable_type, :session_hash]
    Document.reindex
  end

  def new
    @document = Document.new
    authorize! :create, @document
  end

  def create
    @document = Document.new document_params
    @document.users << current_user
    authorize! :create, @document

    if @document.save
      redirect_to @document, flash: { success: t('validation.create', model: @document.class.model_name.human.downcase) }
    else
      render 'new'
    end
  end

  def edit
    authorize! :update, @document

    unless @document.users.include? current_user
      @document.users << current_user
    end
  end

  def update
    authorize! :update, @document

    if @document.update document_params
      redirect_to @document, flash: { success: t('validation.update', model: @document.class.model_name.human.downcase) }
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @document

    @document.destroy
    redirect_to new_document_path, flash: { success: t('validation.destroy', model: @document.class.model_name.human.downcase) }
  end

  def zip
    txt_file = File.new("#{@document.title}.txt", 'w+')
    txt_file.puts('# ' + @document.title)
    txt_file.puts('')
    txt_file.puts('## ' + @document.description)
    txt_file.puts('')
    txt_file.puts(@document.content)
    txt_file.rewind

    if @document.attachments.any?
      t = Tempfile.new("my-temp-filename-#{Time.now}")

      Zip::ZipOutputStream.open(t.path) do |z|
        @document.attachments.each do |attachment|
          z.put_next_entry(@document.title + '/' + File.basename(attachment.path.path).to_s)
          z.print IO.read(Dir.pwd + '/public' + attachment.path.to_s)
        end

        z.put_next_entry(@document.title + '.txt')
        z.print IO.read(txt_file)
      end

      send_file t.path, type: 'application/zip',
                        disposition: 'attachment',
                        filename: "#{@document.title}.zip"
      t.close
    else
      t = Tempfile.new("my-temp-filename-#{Time.now}")

      Zip::ZipOutputStream.open(t.path) do |z|
        z.put_next_entry(@document.title + '.txt')
        z.print IO.read(txt_file)
      end

      send_file t.path, type: 'application/zip',
                        disposition: 'attachment',
                        filename: "#{@document.title}.zip"
      t.close
    end

    File.delete(txt_file)
  end

private

  def set_document
    @document = Document.friendly.find params[:id]
  end

  def document_params
    params.require(:document).permit(:content, :description, :title, attachments_attributes: [:id, :path, :_destroy], user_ids: [], tag_ids: [])
  end
end
