require 'swagger_helper'

RSpec.describe 'API::V1::Urls', type: :request do
  let(:access_token) { '12345-secure-token-67890' }
  let(:Authorization) { "Bearer #{access_token}" }

  path '/api/v1/urls' do
    post 'Create a shortened URL' do
      tags 'URLs'
      consumes 'application/json'
      produces 'application/json'

      security [BearerAuth: []]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token for authentication'

      parameter name: :url, in: :body, schema: {
        type: :object,
        properties: {
          original_url: { type: :string }
        },
        required: ['original_url']
      }

      response '201', 'URL created' do
        let(:url) { { original_url: 'http://example.com' } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['short_url']).not_to be_nil
        end
      end

      response '422', 'Invalid URL' do
        let(:url) { { original_url: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/urls/{short_url}' do
    get 'Retrieve original URL by short URL' do
      tags 'URLs'
      produces 'application/json'

      security [BearerAuth: []]
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer token for authentication'

      parameter name: :short_url, in: :path, type: :string, description: 'Shortened URL identifier'

      response '200', 'URL found' do
        let(:short_url) { Url.create(original_url: 'http://example.com').short_url }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['original_url']).to eq('http://example.com')
        end
      end

      response '404', 'URL not found' do
        let(:short_url) { 'invalid' }
        run_test!
      end
    end
  end
end
