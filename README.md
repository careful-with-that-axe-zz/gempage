# Gempage

Gempage generates a reference web page listing all the gems installed within a Rails application. It is based
off a version I use within my prototyping application.  Best case scenario it speeds up the process of finding
source code and documentation of the gems you are using. And though the overall design is simplistic and rather
garish (I like color), who doesn't like adorable octocat icons everywhere?  And the dual group gems are my favorite.

A live example: [http://fathomless-tundra-4874.herokuapp.com/gempage](http://fathomless-tundra-4874.herokuapp.com/gempage)

This is very much a work in progress and is at a minimal viable project level now.

## Installation

1. Add `gem 'gempage'` to your Gemfile, then run `bundle`

2. Within terminal in your application root directory type and enter `gempage generate` to create the Gemfile HTML listing.
There is one option which is `--color` or `-c` which can be set to `pastels` or `random`

3. The page will be viewable at `http://{your_application_url}/gempage`

## Plans for the Future

* Hover state now has gem info, that should look better and have author, downloads and other details in it.
* Version information, require: false, etc should display within the gem.
* Ack! This thing needs tests, it should have been TDD project if had time.
* Minify assets.
* Design more space sensitive, lots of scrolling now.
* Users should be able to specify a color scheme. *Update*: This functionality has been added though the available color schemes are very limited and dubious.
* Order by group and gem name rather than placement in Gemfile?
* Create an api of my own to supplement missing content, it doesn't save as much time if so many links are missing
* Integrate with a RailsCast project to add those links to the appropriate gems.
