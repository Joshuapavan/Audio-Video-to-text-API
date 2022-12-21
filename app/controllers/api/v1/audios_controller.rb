class Api::V1::AudiosController < BaseController
  before_action :set_audio, only: %i[ show update destroy ]

  # GET api/v1/audios
  def index
    @audios = current_user.audios

    render json:{
      message: "Successfully rendered all the audios of the current user",
      user: current_user,
      audio_transcrptions: @audios
    }, status: :ok
  end

  # GET api/v1/audios/1
  def show
    if @audio
      render json:{
        message: "Rendered the audio with the ID: #{params[:id]}",
        user: current_user,
        audio_file: @audio_file,
        audio_url: @audio_url,
        transcription: @audio.to_string
      }, status: :ok
    else
      render json:{
        message: "Unable to get the audio with the given ID: #{params[:id]}",
        error: @audio.error.full_messages
        user: current_user
      }, status: :unprocessable_entity
    end
  end


  # POST api/v1/audios
  def create
    @audio = current_user.audios.create(audio_params)
    @audio.save

    # returns full path to the document stored locally on disk
    active_storage_disk_service = ActiveStorage::Service::DiskService.new(root: Rails.root.to_s + '/storage/')
    @audio_file = active_storage_disk_service.send(:path_for, @audio.audio_file.blob.key)


    audio_service = Api::V1::AudioService.new()
    transcription = audio_service.upload(@audio_file)

    @audio.update(to_string: transcription)

    if @audio
      render json:{
        message: "Successfully added the audio to the signed in user.",
        user: current_user,
        audio_file: @audio_file,
        audio_url: @audio_url
        transcribed_text: @audio.to_string
      },status: :created
    else
      render json:{
        message: @audio.errors.full_messages
      },status: :unprocessable_entity
    end
  end


  # DELETE api/v1/audios/1
  def destroy
    if @audio.destroy
      render json:{
        message: "Removed the audio with id #{params[:id]}",
        user: current_user
      }, status: :ok
    else
      render json:{
        message: "Error while removing the audio.",
        error: @audio.error.full_messages,
        user: current_user
      }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audio
      @audio = current_user.audios.find(params[:id])
      @audio_url = AudioSerializer.new(@audio).audio_file,
    end

    # Only allow a list of trusted parameters through.
    def audio_params
      params.permit(:audio_file)
    end
end
