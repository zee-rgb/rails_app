# frozen_string_literal: true

module Api
  class AiController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :validate_text_param, only: :analyze

    def analyze
      result = AiService.analyze_text(text: params[:text])
      render json: result
    rescue AiService::AiError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    private

    def validate_text_param
      return if params[:text].present?

      render json: { error: "Text parameter is required" }, status: :bad_request
    end
  end
end
