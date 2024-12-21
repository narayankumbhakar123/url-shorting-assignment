module Api
    module V1
      class UrlsController < ApplicationController
        protect_from_forgery with: :null_session
        before_action :authenticate_api_token
  
        def create
          url = Url.new(url_params)
          if url.save
            render json: { short_url: url.short_url, original_url: url.original_url }, status: :created
          else
            render json: { error: url.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def show
          url = Url.find_by(short_url: params[:short_url])
          if url
            render json: { short_url: url.short_url, original_url: url.original_url }, status: :ok
          else
            render json: { error: 'URL not found' }, status: :not_found
          end
        end
  
        private
  
        def url_params
          params.require(:url).permit(:original_url)
        end
  
        def authenticate_api_token
          token = request.headers['Authorization']
          unless token == Rails.application.config.api_token
            render json: { error: 'Unauthorized' }, status: :unauthorized
          end
        end
      end
    end
  end
  