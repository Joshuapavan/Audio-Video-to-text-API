class Api::V1::TranscribeController < BaseController


  def transcribe

  end


  private
  def get_audio
    @audio = Audio.last.to_json(include: [:audio])
  end

end
