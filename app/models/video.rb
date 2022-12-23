class Video < ApplicationRecord
    has_one_attached :video_file
    belongs_to :user
end
