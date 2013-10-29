v0.0.2, 2013-10-24
-------------------

  * [REFACTORING] Create Sass mixin to replace all that color setting css.  Set scheme colors
    as variables so they are reusable and self documenting. Organized asset directory and set
    up assets:compile task to automatically process any color scheme scss files into css. changed
    public/colorscheme to color-scheme. Starting all gem-colors at one instead of zero. Removed
    argument restriction of of executable, if user enters nonexistent color scheme it will just
    get set as default. Adding color setting to public/application.css during the generating
    phase to avoid having to set overrides.  Refactored default versus custom color scheme code
    in generate.rb.

v0.0.3, 2013-10-29
-------------------

  * [REFACTORING] Refactored for performance, readability, testability. Removal of unnecessary
    parameters, redundant method calls and another couple levels of unnecessary hash rewriting.
    Separated Importer functionality into two classes, GemfileProcessor and RubyGemInfo. Moved
    grouping of gems into view, possible temporary move, and set view to use hash as is from
    JSON.parse instead of expecting symbols as keys.
  * [BUGFIX] Performance fixes! Benchmark.measure { Gempage.generate } for 6 gem groups and
    21 gems is now is at `0.060000   0.010000   0.070000 (  6.475024)` versus
    `0.410000   0.100000   0.510000 ( 49.683921)` in version 0.0.2.
  * [FEATURE] Added some very rudimentary tests for the gemfile processor and ruby gem info
    snagging part.
  * [FEATURE] Missing gem (most likely in the case of vendored gems) and issues with snagging
    gem info from rubygems.org now log their errors within the gempage.  This is a rough draft of
    a more informative reporting system.
