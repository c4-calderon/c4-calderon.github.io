source 'https://rubygems.org'

gem 'jekyll', '~> 3.10.0'
gem 'webrick', '~> 1.8'
gem 'tzinfo', '~> 2.0'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'github-pages'
gem 'connection_pool', '2.5.0'

group :jekyll_plugins do
  gem 'jekyll-feed'
  gem 'jekyll-sitemap'
  gem 'jekyll-redirect-from'
  gem 'jemoji'
end
