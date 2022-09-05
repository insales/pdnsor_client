# frozen_string_literal: true

Gem::Specification.new do |gem|
  gem.name        = 'pdnsor_client'
  gem.version     = '0.0.2'
  gem.author      = 'Max Melentiev'
  gem.email       = 'maxim.melentiev@insales.ru'
  gem.summary     = "PowerDNS on Rails api.v1 client"

  gem.files       = Dir['lib/**/*.rb']
  gem.platform    = Gem::Platform::RUBY
  gem.required_ruby_version = ">= 2.0"

  gem.add_dependency 'activesupport'
  gem.add_dependency 'rest-client'
end
