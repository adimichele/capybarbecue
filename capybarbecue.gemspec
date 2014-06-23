# -*- encoding: utf-8 -*-

require './lib/capybarbecue/version'

Gem::Specification.new do |s|
  s.name = "capybarbecue"
  s.version = Capybarbecue::VERSION

  s.required_ruby_version = ">= 1.9.3"
  s.authors = ["Andrew DiMichele"]
  s.date = "2013-08-05"
  s.description = "Makes fundamental changes to Capybara's threading architecture so you can write stable tests with a shared database connection."
  s.email = "backflip@gmail.com"
  s.files = Dir.glob("{lib,spec}/**/*") + %w(README.md LICENSE.txt)
  s.homepage = "http://github.com/adimichele/capybarbecue"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Makes your Capybara test suite work better"

  s.add_runtime_dependency('activesupport')
  s.add_runtime_dependency('capybara', ["~> 2"])

  s.add_development_dependency('rspec')
  s.add_development_dependency('rr')
  s.add_development_dependency('yard')
  s.add_development_dependency('bundler')
  s.add_development_dependency('poltergeist')
  s.add_development_dependency('launchy')
  s.add_development_dependency('rake')
end

