require "test_helper"

class AudiosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @audio = audios(:one)
  end

  test "should get index" do
    get audios_url, as: :json
    assert_response :success
  end

  test "should create audio" do
    assert_difference("Audio.count") do
      post audios_url, params: { audio: { to_string: @audio.to_string, user_id: @audio.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show audio" do
    get audio_url(@audio), as: :json
    assert_response :success
  end

  test "should update audio" do
    patch audio_url(@audio), params: { audio: { to_string: @audio.to_string, user_id: @audio.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy audio" do
    assert_difference("Audio.count", -1) do
      delete audio_url(@audio), as: :json
    end

    assert_response :no_content
  end
end
