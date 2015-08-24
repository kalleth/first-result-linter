require 'spec_helper'
require 'first_result_linter'

describe FirstResultLinter do
  let(:term) { "cheesy wotsits" }
  let(:first_result) { 'https://en.wikipedia.org/wiki/Wotsits' }
  let(:searcher) { double(:searcher, call: first_result) }
  let(:validator) { double(:validator) }

  before do
    stub_request(:get, first_result)
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
end
