Rails.application.routes.draw do
  defaults format: :json do
    namespace :v1 do
      scope :users do
        resources :check_status, only: [:create]
      end
    end
  end
end
