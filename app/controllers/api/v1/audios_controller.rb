class Api::V1::AudiosController < BaseController
  before_action :set_audio, only: %i[ show update destroy ]

  # GET /audios
  def index
    @audios = current_user.audios

    render json:{
      audio_transcrptions: @audios
    }
  end

  # GET /audios/1
  def show
    render json: @audio
  end


  # POST api/v1/audios
  def create
    @audio = current_user.audios.create(audio_params)
    @audio.save

    active_storage_disk_service = ActiveStorage::Service::DiskService.new(root: Rails.root.to_s + '/storage/')

    audio_file = active_storage_disk_service.send(:path_for, @audio.audio_file.blob.key)
  # => returns full path to the document stored locally on disk

    audio_service = Api::V1::AudioService.new()

    transcription = audio_service.upload(audio_file)

    @audio.update(to_string: transcription)

    if @audio
      render json:{
        message: "Successfully added the audio to the signed in user.",
        user: current_user,
        audio_file: audio_file,
        audio_url: AudioSerializer.new(@audio).audio_file,
        transcribed_text: @audio.to_string
      },status: :created
    else
      render json:{
        message: @audio.errors.full_messages
      },status: :unprocessable_entity
    end
  end


  # DELETE /audios/1
  def destroy
    @audio.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = current_user.audios.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def audio_params
      params.permit(:audio_file)
    end
end
