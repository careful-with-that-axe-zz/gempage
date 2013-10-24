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
