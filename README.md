[![Circle CI](https://circleci.com/gh/kalleth/first-result-linter/tree/master.svg?style=svg)](https://circleci.com/gh/kalleth/first-result-linter/tree/master)

# Brief

Write an application that searches for a provided term on google, then clicks
on the first link and lints the HTML on the page using W3C. The application
should not assume that it will always use google or W3C.

## Assumptions
I've assumed that "clicks on the first link" from the brief is paraphrasing
(rather than typing out "makes a request to" each time) and
used simple Net::HTTP requests to implement the behaviour specified in most
cases, other than sending multipart form data to W3C, for which I've used
RestClient.

However, a downside of this is a dependency on W3C accepting cross-origin POST
requests, and a dependency on the HTML structure of Google search results.

I could use a library like `mechanize` or similar to drive a web browser (even
a pseudo one) instead to mitigate this, at the expense of much higher overhead
when running the code.

## A note on git strategy

Normally I would use feature branches, bugfix branches, and pull requests.
However, as I'm the only person working on this project there's no need; I'm
going to work directly on master.

## Quickstart

    git clone git@github.com:kalleth/first-result-linter.git
    cd first-result-linter/
    # install ruby 2.2 if required; your ruby version manager should handle this
    # rvm/rbenv install 2.2

### App

    $ ./first_result_linter "cheesy wotsits"

    Linting the first result on google for 'cheesy wotsits'
    RESULTS:

    Category: Info
      The Content-Type was text/html. Using the HTML parser.

    Category: Info
      Using the schema for HTML with SVG 1.1, MathML 3.0, RDFa 1.1, and ITS 2.0 support.

    Category: Error
      Element link is missing required attribute property.
      From line 451, column 1; to line 451, column 298


### Test suite

    bundle exec rspec

## Adding more searchers and linters

### New Searcher
* Ensure a `Search::DuckDuckGo` (or other) matches this API:
  * `#call(term)` returns the URL of the first result
* Switch it out in the initializer of `FirstResultLinter`

### New Linter
* Ensure a `Linter::HTMLTidy` (or other) matches this API:
  * `#call(html)` returns an array of `Linter::Response` objects.

## Future enhancements
* Output the URL returned / that's being linted. This will involve
  restructuring the linter to perform linting and fetching in a two stage
  process, or returning a two-element return value.
* Extract the fetching of the HTML of the first result from the Orchestrating
  class (`FirstResultLinter`) to a class with the sole responsibility of
  fetching the HTML.
* Add an integration test which runs the script directly using a VCR cassette.
* Refactor `Linter::W3C#parse` so it doesn't violate demeter so much.

