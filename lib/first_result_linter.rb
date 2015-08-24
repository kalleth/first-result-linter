require 'net/http'

class FirstResultLinter
  class ScrapeError < StandardError; end
  class InvalidURI < StandardError; end

  def initialize(searcher, linter)
    @searcher = searcher
    @linter = linter
  end

  def call(term)
    linter.call(
      source(
        searcher.call(term)
      )
    )
  end

private
  attr_reader :searcher, :linter

  # Using Net::HTTP.get here prevents us having to capture all edge cases; so
  # long as the URI is valid any request will just return a nil body in error
  # cases.
  #
  # For socket problems or deeper issues with making a web request, we'll let
  # the error bubble up (as they provide more meaningful output) for now.
  #
  # I'm making the conscious decision that handling every kind of network error
  # is outside the scope of this exercise.
  def source(url)
    uri = URI(url)
    raise InvalidURI, "Invalid URL: #{url}" if uri.host.nil?

    Net::HTTP.get(uri).tap do |page_content|
      raise ScrapeError, "No content returned from #{url}" if page_content.nil?
    end
  end
end
