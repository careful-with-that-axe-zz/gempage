# Gempage

Gempage generates a reference web page listing all the gems installed within a Rails application. It is based
off a version I use within my prototyping application.  Best case scenario it speeds up the process of finding
source code and documentation of the gems you are using. And though the overall design is simplistic and rather
garish (I like color), who doesn't like adorable octocat icons everywhere?  And the dual group gems are my favorite.

A live example: [http://fathomless-tundra-4874.herokuapp.com/gempage](http://fathomless-tundra-4874.herokuapp.com/gempage)

This is very much a work in progress and is at a sub minimal viable project level now.

## Installation

No way this is becoming an actual gem, especially in current state, so it has be installed as a vendored gem in order to work.

1. Checkout the source code: `git clone git@github.com:careful-with-that-axe/gempage.git`

2. In the gempage directory run `gem build gempage.gemspec` and `gem install path_to_gempage_directory/gempage-0.0.1.gem`

3. In a rails application directory run the following command to `vendor` the gem: `gem unpack gempage --target vendor/gems`

4. Add `gem 'gempage', :path => "vendor/gems/gempage-0.0.1"` to your Gemfile, then run `bundle`

5. In your application directory, start rails console `rails console`

6. Enter `Gempage.generate` which will create an HTML page in your public directory based.

7. The page will be viewable at `http://{your_application_url}/gempage`

## Plans for the Future

* Refactor so the whole thing isn't class methods, that isn't my usual style but I was pressed for time and
following an example.
* Hover state now has gem info, that should look better and have author, downloads and other details in it.
* Should be able to run from command line, not just rails console.
* Version information, require: false, etc should display within the gem.
* Ack! This thing needs tests, it should have been TDD project if had time.
* Design more space sensitive, lots of scrolling now.
* Users should be able to specify a color scheme.
* Order by group and gem name rather than placement in Gemfile?
* Create an api of my own to supplement missing content, it doesn't save as much time if so many links are missing
