class Api::V1::VideosController < BaseController
    before_action :set_video, only: %i[ show update destroy ]
  
    # GET api/v1/videos
    def index
      @videos = current_user.videos
  
      render json:{
        message: "Successfully rendered all the videos of the current user",
        user: current_user,
        video_transcrptions: @videos
      }, status: :ok
    end
  
    # GET api/v1/videos/1
    def show
      if @video
        render json:{
          message: "Rendered the video with the ID: #{params[:id]}",
          user: current_user,
          video_file: @video_file,
          video_url: @video_url,
          transcription: @video.to_string
        }, status: :ok
      else
        render json:{
          message: "Unable to get the video with the given ID: #{params[:id]}",
          error: @video.error.full_messages,
          user: current_user
        }, status: :unprocessable_entity
      end
    end
  
  
    # POST api/v1/videos
    def create
      flagged_words = ['shit', 'iphone', 'apple']
      @video = current_user.videos.create(video_params)
      @video.save
  
      # returns full path to the document stored locally on disk
      active_storage_disk_service = ActiveStorage::Service::DiskService.new(root: Rails.root.to_s + '/storage/')
      @video_file = active_storage_disk_service.send(:path_for, @video.video_file.blob.key)
  
  
      video_service = Api::V1::TranscriptionService.new()
      transcription = video_service.upload(@video_file)
  
      transcribed_words = transcription.split(/\W+/).to_a
  
      for word in transcribed_words
        if flagged_words.include?(word.downcase)
          current_user.flagged_words_count += 1
          current_user.save()
        end
      end
  
      if current_user.flagged_words_count >= 3
        current_user.blocked = true
        current_user.save()
      end
  
      @video.update(to_string: transcription)
  
      if @video
        render json:{
          message: "Successfully added the video to the signed in user.",
          user: current_user,
          video_file: @video_file,
          video_url: @video_url,
          transcribed_text: @video.to_string
        },status: :created
      else
        render json:{
          message: @video.errors.full_messages
        },status: :unprocessable_entity
      end
    end
  
  
    # DELETE api/v1/videos/1
    def destroy
      if @video.destroy
        render json:{
          message: "Removed the video with id #{params[:id]}",
          user: current_user
        }, status: :ok
      else
        render json:{
          message: "Error while removing the video.",
          error: @video.error.full_messages,
          user: current_user
        }, status: :unprocessable_entity
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_video

        @video = current_user.videos.find(params[:id])
        @video_url = VideoSerializer.new(@video).video_file
      end
  
      # Only allow a list of trusted parameters through.
      def video_params
        params.permit(:video_file)
      end
  end
  