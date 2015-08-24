require 'spec_helper'
require 'first_result_linter'

describe FirstResultLinter do
  let(:term) { "cheesy wotsits" }
  let(:first_result) { 'https://en.wikipedia.org/wiki/Wotsits' }
  let(:searcher) { double(:searcher, call: first_result) }
  let(:validator) { double(:validator) }

  before do
    stub_request(:get, first_result).to_return(body: "<html></html>")
  end

  subject(:first_result_linter) { FirstResultLinter.new(searcher, validator) }

  it "asks the searcher for the first result" do
    first_result_linter.call(term)

    expect(searcher).to have_received(:call).with(term)
  end

  it "makes a request to the URL returned by the searcher" do
    first_result_linter.call(term)

    expect(a_request(:get, first_result)).to have_been_made.once
  end

  [301, 404, 500].each do |code|
    it "gracefully handles HTTP #{code} errors" do
      stub_request(:get, first_result).to_return(status: code)

      expect { first_result_linter.call(term) }.to raise_error(FirstResultLinter::ScrapeError)
    end
  end

  context "with an invalid URI" do
    let(:first_result) { 'htflibble/not-a-real-uri' }

    it "gracefully raises" do
      expect { first_result_linter.call(term) }.to raise_error(FirstResultLinter::InvalidURI)
    end
  end
end
