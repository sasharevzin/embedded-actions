# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "embedded_actions"
  s.version     = "2.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sebastian Delmont", "Jerret Taylor", "Ryan Barber", "Andreas Simon", "Jonathan Boler"]
  s.email       = ["rfb@skyscraper.nu"]
  s.homepage    = "http://github.com/rfb/embedded-actions"
  s.summary     = ""
  s.description = ""
 
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "bundler"
 
  s.files        = Dir.glob("{lib}/**/*") + %w(README)
  s.require_path = 'lib'
end
