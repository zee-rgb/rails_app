# frozen_string_literal: true

class AiService
  class AiError < StandardError; end

  def self.analyze_text(text:)
    return mock_analysis(text) if Rails.env.test?

    response = connection.post("/analyze") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = { text: text }.to_json
    end

    handle_response(response)
  rescue Faraday::Error => e
    Rails.logger.error("AI Service Error: #{e.message}")
    raise AiError, "Unable to process your request at this time"
  end

  private

  def self.connection
    @connection ||= Faraday.new(
      url: ENV.fetch("AI_SERVICE_URL", "http://localhost:8000"),
      request: { timeout: 30 }
    )
  end

  def self.handle_response(response)
    case response.status
    when 200..299
      JSON.parse(response.body, symbolize_names: true)
    else
      error = JSON.parse(response.body) rescue { error: "Unknown error" }
      raise AiError, error[:error] || "Analysis failed"
    end
  end

  def self.mock_analysis(text)
    {
      sentiment: %w[positive negative neutral].sample,
      confidence: rand(0.5..1.0).round(2),
      processed_text: text.upcase
    }
  end
end
