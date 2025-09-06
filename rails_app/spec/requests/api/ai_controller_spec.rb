# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::AiController', type: :request do
  describe 'POST /api/analyze' do
    context 'with valid text' do
      let(:valid_params) { { text: 'This is a test' } }
      let(:mock_analysis) do
        {
          sentiment: 'positive',
          confidence: 0.95,
          processed_text: 'THIS IS A TEST'
        }
      end

      before do
        allow(AiService).to receive(:analyze_text).and_return(mock_analysis)
        post '/api/analyze', params: valid_params, as: :json
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns the analysis result' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:sentiment]).to eq('positive')
        expect(json_response[:confidence]).to eq(0.95)
        expect(json_response[:processed_text]).to eq('THIS IS A TEST')
      end
    end

    context 'with missing text parameter' do
      before { post '/api/analyze', params: {}, as: :json }

      it 'returns http bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq('Text parameter is required')
      end
    end

    context 'when AI service raises an error' do
      before do
        allow(AiService).to receive(:analyze_text).and_raise(AiService::AiError, 'Service unavailable')
        post '/api/analyze', params: { text: 'test' }, as: :json
      end

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the error message' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:error]).to eq('Service unavailable')
      end
    end
  end
end
