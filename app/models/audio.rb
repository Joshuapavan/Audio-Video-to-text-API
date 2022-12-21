class Audio < ApplicationRecord
  has_one_attached :audio_file
  belongs_to :user
end
