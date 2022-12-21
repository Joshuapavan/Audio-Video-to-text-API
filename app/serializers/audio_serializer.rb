class AudioSerializer < ActiveModel::Serializer
  attributes :id, :audio_file, :to_string

  include Rails.application.routes.url_helpers

  def audio_file
    rails_blob_path(object.audio_file, only_path: true) if object.audio_file.attached?
  end

  def to_string
    object.to_string
  end
end
