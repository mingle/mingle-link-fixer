lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name        = "mingle-link-fixer"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill DePhillips"]
  s.email       = ["bill.dephillips@gmail.com"]
  s.licenses    = ['Apache']
  s.homepage    = "https://github.com/thoughtworksstudios/mingle-link-fixer"
  s.summary     = "fixes attachment links if you relocate a project"
  s.description = "fixes inline attachment links when a project is relocated"

  s.executables << 'mingle-link-fixer'

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.require_path = 'lib'
end
