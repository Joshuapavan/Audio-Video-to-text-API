require 'json'
require 'net/http'
require 'openssl'

$api_key = 'add your api key here'
$upload_url = 'https://api.assemblyai.com/v2/upload'
$transcribe_url = 'https://api.assemblyai.com/v2/transcript'

class Api::V1::TranscriptionService

  def upload(file_path)
    uri = URI($upload_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(
      uri,
      'authorization'     => $api_key,
      'transfer-encoding' => 'chunked'
    )
    request.body_stream = File.open(file_path,'rb')
    response = http.start do |http|
      http.request(request)
    end

    result = JSON.parse(response.body)
    transcribe_audio(result["upload_url"])
  end

  def transcribe_audio(audio_url)
    uri = URI($transcribe_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(
      uri,
      'authorization' => $api_key,
    )
    request.body = { 'audio_url' => audio_url }.to_json
    response = http.request(request)

    result = JSON.parse(response.body)
    fetch_text(result["id"])
  end

  def fetch_text(transcription_id)
    max_tries = 10
    uri = URI("#{$transcribe_url}/#{transcription_id}")

    while true
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(
        uri,
        'authorization' => $api_key,
      )

      response = http.request(request)

      result = JSON.parse(response.body)

      if(result["status"] == 'completed' or max_tries <= 0)
        break
      end

      sleep(10)
    end

    if result["status"] == 'completed'
      return result["text"]
    else
      raise "\n\nUnable to transcribe text.\nError : #{result["error"]}"
    end
  end

end
