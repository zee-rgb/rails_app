# frozen_string_literal: true

require "rails_helper"

RSpec.describe AiService, type: :service do
  describe ".analyze_text" do
    context "when the AI service is available" do
      let(:text) { "This is a positive test" }
      let(:mock_response) do
        {
          sentiment: "positive",
          confidence: 0.95,
          processed_text: "THIS IS A POSITIVE TEST"
        }
      end

      before do
        stub_request(:post, "http://ai_service:8000/analyze")
          .with(
            body: { text: text }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
          .to_return(
            status: 200,
            body: mock_response.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns the analysis result" do
        result = described_class.analyze_text(text: text)

        expect(result[:sentiment]).to eq("positive")
        expect(result[:confidence]).to be_a(Float)
        expect(result[:processed_text]).to eq("THIS IS A POSITIVE TEST")
      end
    end

    context "when the AI service is not available" do
      before do
        stub_request(:post, "http://ai_service:8000/analyze")
          .to_raise(Faraday::ConnectionFailed.new("Connection failed"))
      end

      it "raises an AiError" do
        expect {
          described_class.analyze_text(text: "test")
        }.to raise_error(AiService::AiError, "Unable to process your request at this time")
      end
    end
  end

  describe "mock_analysis" do
    it "returns a valid analysis structure" do
      result = described_class.send(:mock_analysis, "test")

      expect(result).to have_key(:sentiment)
      expect(result).to have_key(:confidence)
      expect(result).to have_key(:processed_text)

      expect(%w[positive negative neutral]).to include(result[:sentiment])
      expect(result[:confidence]).to be_between(0.5, 1.0)
      expect(result[:processed_text]).to eq("TEST")
    end
  end
end
