Rails.application.routes.draw do
  devise_for :users,controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    }

  namespace :api do
    namespace :v1 do
      resources :audios
    end
  end

  # resources :audios

  post 'api/v1/transcribe_audio', to: 'api/v1/audios#create'
end
