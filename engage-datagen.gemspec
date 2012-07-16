Gem::Specification.new do |s|
  s.name        = 'engage-datagen'
  s.version     = '0.0.5'
  s.date        = '2012-07-16'
  s.summary     = "Utility for generating known datasets in the Engage app"
  s.description = "Helps with automated testing"
  s.authors     = ["Jace Bennett", "Patrick Boudreaux", "Claire Moss"]
  s.email       = 'jbennett@daxko.com'
  s.files       = Dir[
      "LICENSE",
      "readme.md",
      "lib/**/*.rb"
  ]
  s.homepage    = 'http://github.com/daxko/engage-datagen/'

  s.add_development_dependency 'rspec', '>= 2.8.0'
  s.add_dependency 'activesupport'
  s.add_dependency 'rest-client'
end
