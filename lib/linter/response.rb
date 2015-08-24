module Linter
  class Response
    attr_reader :category, :title, :location, :body

    def initialize(category: 'Misc', title:, location: nil, body: nil)
      @category = category
      @title = title
      @location = location
      @body = body
    end
  end
end
