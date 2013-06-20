require 'rack/offline'

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end


with_layout :text do
    page '/texts/*'
end


with_layout :layout do
  page '/texts/*/index.*'
end


with_layout :topic do
    page '/topics/*'
    page '/glossariy/*'
end

with_layout :persona do
  page '/personalii/*'
end

set :relative_links, true


# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
helpers do
  def current_page_title
    (current_page.data.title? && current_page.data.title)  || 'PAPPUSH'
  end
end

set :css_dir, 'css'
set :js_dir, 'js'
set :images_dir, 'img'
set :partials_dir, 'partials'


# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster
  
  activate :asset_hash, :exts => %w(.jpg .jpeg .png .gif .js .css .otf .woff .eot .ttf .svg), :ignore => [/startup/, /apple-touch-icon/]

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  #set :http_path, "/mp"
end

offline = Rack::Offline.configure {}
map('/offline.appcache') { run offline }
endpoint 'offline.appcache'

ALLOWED_EXTS = %w(css eot gif html jpg png svg ttf txt woff xml js)

ready do
  all_pages = sitemap.resources.map{|r| r.destination_path }
	offline = Rack::Offline.configure do
		all_pages.each do|page|
      cache page if ALLOWED_EXTS.any? {|ext| ext == page[/(\w+)$/]}
    end
    network "*"
	end
end