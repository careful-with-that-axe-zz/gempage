# Gempage

Gempage generates a static reference page listing all the gems installed within a Rails application grouped
and color coded by environment. Each gem listed has links to its Github repository and/or documentation depending
on the information retrieved from [RubyGems.org](https://rubygems.org/).

![screenshot](https://cloud.githubusercontent.com/assets/3504335/7000902/1ddf93ec-dbe3-11e4-8e2e-ef19e6d59cb9.png)

## Installation

1. Add `gem 'gempage'` to your Gemfile, then run `bundle`

2. Within terminal in your application root directory type and enter `gempage generate` to create the Gemfile HTML listing.
There is one option which is `--color` or `-c` which can be set to `pastels` or `random`

3. The page will be viewable at `http://{your_application_url}/gempage`

## Plans for the Future

* Hover state currently has gem info, improve appearance and include more information such as author, download count.
* Version information, require: false, etc should display within the gem.
* Add tests.
* Minify assets.
* Redesign to be more space sensitive.
* Add more color schemes, possibly non-dubious ones.
* Order by group and gem name rather than placement in Gemfile?
