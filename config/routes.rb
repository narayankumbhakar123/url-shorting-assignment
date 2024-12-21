Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root 'urls#index' # Set the index page as the root URL
  resources :urls, only: [:index, :new, :create, :show]
  get '/:short_url', to: 'urls#redirect_to_original', as: :short_url

  namespace :api do
    namespace :v1 do
      resources :urls, only: [:create]
      get '/urls/:short_url', to: 'urls#show', as: :api_short_url
    end
  end
end
