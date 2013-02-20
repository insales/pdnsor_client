Gem::Specification.new do |s|
  s.name        = 'pdnsor_client'
  s.version     = '0.0.1'
  s.author      = 'Max Melentiev'
  s.email       = 'maxim.melentiev@insales.ru'
  s.summary     = "PowerDNS on Rails api.v1 client"
  s.files       = Dir['lib/**/*.rb']
  s.platform    = Gem::Platform::RUBY
  s.add_dependency 'rest-client'
  s.add_dependency 'activesupport'
end