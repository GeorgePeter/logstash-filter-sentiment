# encoding: utf-8
require 'logstash-core'
require "logstash/codecs/base"
require 'logstash/filters/sentiment'

describe LogStash::Filters::Sentiment do

  let(:cleartext) do
    'I love ruby'
  end

  describe 'single event, sentiment' do
    let(:event) do
      LogStash::Event.new(LogStash::Json.load("{\"message\":\"#{cleartext}\"}"))
    end

    let(:sentiment) do
      described_class.new(
        
        "source" => "message",
        "target" => "sentiment"
      )
    end

    let(:result) do
      sentiment.filter(event)
      event
    end

    it 'validate initial cleartext message' do
      expect(result.get("message")).to eq(cleartext)
    end

    it 'check sentiment' do
      expect(result.get("sentiment")).to eq(0.925)
    end

  end  
end
