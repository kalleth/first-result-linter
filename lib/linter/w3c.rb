require 'nokogiri'
require 'rest-client'
require_relative 'response'

module Linter
  class ResponseError < StandardError; end

  class W3C
    ENDPOINT = "https://validator.w3.org/nu/"

    def call(html)
      parse(
        fetch(html)
      )
    end

  private
    def fetch(html)
      RestClient.post(
        ENDPOINT,
        {
          fragment: html,
          multipart: true,
        }
      )
    rescue RestClient::Exception
      raise ResponseError, "Invalid response from W3C"
    end

    def parse(response)
      html = Nokogiri::HTML(response)

      html.css('#results ol:first li').map do |item|
        Linter::Response.new(
          category: item.attr('class').capitalize,
          title: item.css("p:first span").text,
          location: item.css("p:nth-child(2)").text,
        )
      end
    end
  end
end
