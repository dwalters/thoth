# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'thoth/version'

Gem::Specification.new do |s|
  s.rubyforge_project = 'riposte'

  s.name     = 'thoth'
  s.version  = Thoth::APP_VERSION
  s.author   = Thoth::APP_AUTHOR
  s.email    = Thoth::APP_EMAIL
  s.homepage = Thoth::APP_URL
  s.platform = Gem::Platform::RUBY
  s.summary  = 'An awesome blog engine based on Ramaze and Sequel.'

  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE)
  s.executables  = ['thoth']
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.8.6'

  # Runtime dependencies.
  s.add_dependency('ramaze',    '= 2009.10')
  s.add_dependency('builder',   '~> 2.1.2')
  s.add_dependency('cssmin',    '~> 1.0.2')
  s.add_dependency('erubis',    '~> 2.6.2')
  s.add_dependency('json_pure', '~> 1.1.3')
  s.add_dependency('jsmin',     '~> 1.0.1')
  s.add_dependency('RedCloth',  '~> 4.2.1')
  s.add_dependency('sanitize',  '~> 1.2.0')
  s.add_dependency('sequel',    '~> 3.8')

  # Development dependencies.
  s.add_development_dependency('bacon', '~> 1.1.0')
  s.add_development_dependency('rake',  '~> 0.8.0')

  s.post_install_message = <<POST_INSTALL
================================================================================
Thank you for installing Thoth. If you haven't already, you may need to install
one or more of the following gems:

  mysql        - If you want to use Thoth with a MySQL database
  passenger    - If you want to run Thoth under Apache using Phusion Passenger
  sqlite3-ruby - If you want to use Thoth with a SQLite database
  thin         - If you want to run Thoth using Thin
================================================================================
POST_INSTALL
end
