# This configuration file works with both the Compass command line tool and within Rails.

require 'html5-boilerplate'
require 'ninesixty'
# Require any additional compass plugins here.


project_type = :rails
project_path = Compass::AppIntegration::Rails.root
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "public/stylesheets"
sass_dir = "src"
images_dir = "images"
javascripts_dir = "public/javascripts"
environment = Compass::AppIntegration::Rails.env
output_style = (environment == :production) ? :compressed : :expanded

# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass app/stylesheets scss && rm -rf sass && mv scss sass
