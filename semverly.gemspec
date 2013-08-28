Gem::Specification.new do |s|
  s.name        = 'semverly'
  s.version     = '1.0.0'
  s.summary     = 'Semantic Versioning parsing and comparison'
  s.description = 'Parses and compares version strings that comply with Semantic Versioning 2.0 (http://semver.org/)'
  s.authors     = ['Steve Madsen']
  s.email       = 'steve@lightyearsoftware.com'
  s.files       = Dir['**/*.rb']
  s.test_files  = Dir['spec/**/*.rb']
  s.homepage    = 'http://github.com/lightyear/semverly'
  s.license     = 'MIT'

  s.add_development_dependency 'rspec', '>= 2.14'
end
