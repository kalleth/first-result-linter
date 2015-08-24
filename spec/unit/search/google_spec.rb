require 'spec_helper'
require 'search/google'

describe Search::Google do
  let(:term) { "cheesy wotsits" }
  # I could inject the endpoint, but it's a specific search class. So I'm not
  # going to, as it's expected that the class will contain the endpoint to use.
  let(:endpoint) { Search::Google::ENDPOINT }

  before do
    stub_request(:get, /#{endpoint}.*/)
      .to_return(status: 200, body: body)
  end

  subject(:searcher) { Search::Google.new }

  context "with a valid search" do
    let(:body) { File.open('spec/fixtures/google_result.html') { |f| f.read } }

    it "requests the search results from google" do
      searcher.call(term)

      expect(
        a_request(:get, endpoint)
          .with(query: hash_including(q: term))
      ).to have_been_made.once
    end

    it "returns the first result" do
      expect(searcher.call(term)).to eq('https://en.wikipedia.org/wiki/Wotsits')
    end
  end

  context "with an invalid search or when the response from google changes" do
    let(:body) { File.open('spec/fixtures/invalid_result.html') { |f| f.read } }

    it "raises an error" do
      expect { searcher.call(term) }.to raise_error("Invalid response from google")
    end
  end
end
