require 'spec_helper'
require 'first_result_linter'

describe FirstResultLinter do
  let(:term) { "cheesy wotsits" }
  let(:searcher) { double(:searcher, call: 'https://en.wikipedia.org/wiki/Wotsits') }
  let(:validator) { double(:validator) }

  subject(:first_result_linter) { FirstResultLinter.new(searcher, validator) }

  it "asks the searcher for the first result" do
    first_result_linter.call(term)

    expect(searcher).to have_received(:call).with(term)
  end
end
