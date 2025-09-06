#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class IntegrationTest
  RAILS_URL = 'http://localhost:3000/api/analyze'.freeze
  PYTHON_URL = 'http://localhost:8000/analyze'.freeze

  def self.run
    test_texts = [
      "I love this! It's amazing!",
      "I hate this! It's terrible!",
      "This is a neutral statement.",
      ""
    ]

    puts "=== Testing Python AI Service ==="
    test_service('Python', PYTHON_URL, test_texts)

    puts "\n=== Testing Rails API (which calls Python) ==="
    test_service('Rails', RAILS_URL, test_texts)
  end

  private

  def self.test_service(service_name, url, texts)
    puts "\nTesting #{service_name} at #{url}"
    puts "-" * 50

    texts.each do |text|
      print "Testing text: #{text[0..30]}... ".ljust(45)
      
      begin
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        
        request = Net::HTTP::Post.new(uri)
        request['Content-Type'] = 'application/json'
        request.body = { text: text }.to_json
        
        response = http.request(request)
        
        if response.code == '200'
          result = JSON.parse(response.body, symbolize_names: true)
          puts "✅ Success! Sentiment: #{result[:sentiment]}, " \
               "Confidence: #{(result[:confidence] * 100).round(1)}%"
        else
          puts "❌ Error (#{response.code}): #{response.body}"
        end
      rescue StandardError => e
        puts "❌ Exception: #{e.message}"
      end
    end
  end
end

# Run the tests if this file is executed directly
if __FILE__ == $PROGRAM_NAME
  puts "Starting integration tests..."
  puts "Make sure both the Rails and Python services are running!"
  puts "=" * 60
  
  IntegrationTest.run
  
  puts "\nTests completed!"
  puts "=" * 60
end
