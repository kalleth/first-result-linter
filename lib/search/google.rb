require 'nokogiri'
require 'cgi'

module Search
  class Google
    ENDPOINT = "https://www.google.co.uk/search" # ?q=

    def call(term)
      first_result(
        response(term)
      )
    end

  private
    def response(term)
      Net::HTTP.get(uri(term))
    end

    def uri(term)
      @uri ||= URI(ENDPOINT).tap do |uri|
        uri.query = URI.encode_www_form(q: term)
      end
    end

    def first_result(html)
      html = Nokogiri::HTML(html)
      first_result_link = html.css('#ires ol li:first h3 a')
      raise "Invalid response from google" if first_result_link.empty?

      query = CGI.parse(first_result_link.attr('href').value)
      query["/url?q"].first
    end
  end
end
