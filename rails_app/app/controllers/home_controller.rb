# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    # Ensure keys are symbols for consistent access in views
    @analysis = session[:last_analysis].deep_symbolize_keys if session[:last_analysis].present?
    @last_text = session[:last_text]
  end

  def analyze
    response = AiService.analyze_text(text: params[:text]).deep_symbolize_keys

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "results",
          partial: "home/results",
          locals: { analysis: response, last_text: params[:text] }
        )
      end
      format.html do
        session[:last_analysis] = response
        session[:last_text] = params[:text]
        redirect_to root_path
      end
    end
  rescue AiService::AiError => e
    flash[:error] = e.message
    redirect_to root_path
  end
end
