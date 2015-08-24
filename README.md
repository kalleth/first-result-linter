# first-result-linter
Technical exercise. Searches google, lints the first result, and prints errors.

# Brief

Write an application that searches for a provided term on google, then clicks
on the first link and lints the HTML on the page using W3C. The application
should not assume that it will always use google or W3C.

# Initial component identification

I think we'll need the following components:

* Entrypoint, accepting a search term as an argument
  * binstub, probably
* Orchestrator, handles instantiating the Searcher and Validator and handing
  off between them, then returning the result to the Orchestrator
  * Initially, the Orchestrator will open() the URL, but i might refactor that
    out to a `Scraper` class. We'll see how complex the implementation turns
    out to be.
* Search, accepting an specific engine class as an argument, defaulting to
  `Search::Google`
  * `Search` instantiated with search term, exposes `first_result` as a method,
    returns URL
  * `Search::Google`
  * `Search::DuckDuckGo` # future enhancement
  * `Search::Bing` # future enhancement
* Linter, accepting a specific Linter as an argument, defaulting to
  `Linter::W3C`.
  * `Linter` instantiated with page HTML, exposes `results` method, which
    returns an enumerable of results
    * These results might be an array of text strings, or an object, depending
      on exactly what results are returned.
  * `Linter::W3C`

# Gem choices (first pass)
* Command line arguments: No gem, as the term will probably be "everything
  provided to the binstub". `ARGV` will do for now.
* Web requests: HTTParty, because everyone likes to party hard.
* Testing: rspec, probably VCR too but I'll add that as required.
