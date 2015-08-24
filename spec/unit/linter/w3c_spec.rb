require 'spec_helper'
require 'linter/w3c'

describe Linter::W3C do
  let(:html) { File.open('spec/fixtures/wotsits_wiki.html') { |f| f.read } }
  let(:endpoint) { Linter::W3C::ENDPOINT }
  let(:body) { File.open('spec/fixtures/wotsits_wiki_w3c_response.html') { |f| f.read } }

  before do
    stub_request(:post, endpoint)
      .to_return(status: 200, body: body)
  end

  subject(:linter) { Linter::W3C.new }

  it "sends the HTML to the W3C validator" do
    linter.call(html)

    expect(
      a_request(:post, endpoint)
    ).to have_been_made.once
  end

  it "returns a result array with the correct entries" do
    expect(linter.call(html)).to be_kind_of(Array)
    expect(linter.call(html).length).to eq(3)
  end

  it "returns the correct results" do
    results = linter.call(html)
    expect(results.map(&:category)).to eq(['Info', 'Info', 'Error'])
    expect(results.map(&:title)).to eq([
      "The Content-Type was text/html. Using the HTML parser.",
      "Using the schema for HTML with SVG 1.1, MathML 3.0, RDFa 1.1, and ITS 2.0 support.",
      "Element link is missing required attribute property.",
    ])
  end

  [301, 404, 500].each do |code|
    it "gracefully handles HTTP #{code} errors" do
      stub_request(:post, endpoint).to_return(status: code)

      expect { linter.call(html) }.to raise_error(Linter::ResponseError)
    end
  end
end
