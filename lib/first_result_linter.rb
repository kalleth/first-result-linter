class FirstResultLinter
  def initialize(searcher, validator)
    @searcher = searcher
    @validator = validator
  end

  def call(term)
  end

private
  attr_reader :searcher, :validator
end
