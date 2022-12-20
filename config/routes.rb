Rails.application.routes.draw do
  devise_for :users,controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
    }

  # namespace :api do
  #   namespace :v1 do
  #     resources :transcribe
  #   end
  # end

  post 'api/v1/transcribe', to: 'transcribe#transcribe'
end
