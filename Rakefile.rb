#--
# Copyright (c) 2008 Ryan Grove <ryan@wonko.com>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   * Neither the name of this project nor the names of its contributors may be
#     used to endorse or promote products derived from this software without
#     specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++

# Append the Thoth /lib directory to the include path if it's not there
# already.
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))
$:.uniq!

require 'find'

require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'thoth/version'

# Don't include resource forks in tarballs on Mac OS X.
ENV['COPY_EXTENDED_ATTRIBUTES_DISABLE'] = 'true'
ENV['COPYFILE_DISABLE'] = 'true'

# Gemspec for Thoth
thoth_gemspec = Gem::Specification.new do |s|
  s.rubyforge_project = 'thoth'

  s.name     = 'thoth'
  s.version  = Thoth::APP_VERSION
  s.author   = Thoth::APP_AUTHOR
  s.email    = Thoth::APP_EMAIL
  s.homepage = Thoth::APP_URL
  s.platform = Gem::Platform::RUBY
  s.summary  = 'A fast and simple blog engine based on Ramaze and Sequel.'

  s.files        = FileList['{bin,lib}/**/*', 'LICENSE'].to_a
  s.executables  = ['thoth']
  s.require_path = 'lib'
  s.has_rdoc     = true

  s.required_ruby_version = '>= 1.8.6'

  s.add_dependency('ramaze',        '~> 0.3.6')
  s.add_dependency('builder',       '>= 2.1.2')
  s.add_dependency('configuration', '>= 0.0.5')
  s.add_dependency('erubis',        '>= 2.5.0')
  s.add_dependency('hpricot',       '>= 0.6')
  s.add_dependency('json_pure',     '>= 1.1.2')
  s.add_dependency('RedCloth',      '>= 3.0.4')
  s.add_dependency('sequel',        '>= 1.3')
  s.add_dependency('sequel_core',   '>= 1.3')
  s.add_dependency('sequel_model',  '>= 0.5.0.2')
  s.add_dependency('thin',          '>= 0.7.1')
end

plugins = []

# del.icio.us plugin
plugins << Gem::Specification.new do |s|
  s.rubyforge_project = 'thoth'

  s.name     = 'thoth_delicious'
  s.version  = Thoth::APP_VERSION
  s.author   = Thoth::APP_AUTHOR
  s.email    = Thoth::APP_EMAIL
  s.homepage = Thoth::APP_URL
  s.platform = Gem::Platform::RUBY
  s.summary  = 'del.icio.us plugin for the Thoth blog engine.'

  s.files        = ['plugin/thoth_delicious.rb']
  s.require_path = 'plugin'
  s.has_rdoc     = true
  
  s.add_dependency('json_pure', '>= 1.1.2')
  s.add_dependency('thoth',     "~> #{Thoth::APP_VERSION}")
end

# Flickr plugin
plugins << Gem::Specification.new do |s|
  s.rubyforge_project = 'thoth'

  s.name     = 'thoth_flickr'
  s.version  = Thoth::APP_VERSION
  s.author   = Thoth::APP_AUTHOR
  s.email    = Thoth::APP_EMAIL
  s.homepage = Thoth::APP_URL
  s.platform = Gem::Platform::RUBY
  s.summary  = 'Flickr plugin for the Thoth blog engine.'

  s.files        = ['plugin/thoth_flickr.rb']
  s.require_path = 'plugin'
  s.has_rdoc     = true
  
  s.add_dependency('net-flickr', '= 0.0.1')
  s.add_dependency('thoth',      "~> #{Thoth::APP_VERSION}")
end

Rake::GemPackageTask.new(thoth_gemspec) do |p|
  p.need_tar_gz = true
end

Rake::RDocTask.new do |rd|
  rd.main     = 'Thoth'
  rd.title    = 'Thoth'
  rd.rdoc_dir = 'doc'

  rd.rdoc_files.include('lib/**/*.rb')
end

Rake::RDocTask.new(:rdoc_delicious) do |rd|
  rd.main     = 'Thoth::Plugin::Delicious'
  rd.title    = 'Thoth::Plugin::Delicious'
  rd.rdoc_dir = 'doc/delicious'
  
  rd.rdoc_files.include('plugin/thoth_delicious.rb')
end

Rake::RDocTask.new(:rdoc_flickr) do |rd|
  rd.main     = 'Thoth::Plugin::Flickr'
  rd.title    = 'Thoth::Plugin::Delicious'
  rd.rdoc_dir = 'doc/flickr'
  
  rd.rdoc_files.include('plugin/thoth_flickr.rb')
end

desc "install Thoth"
task :install => :gem do
  sh "gem install pkg/thoth-#{Thoth::APP_VERSION}.gem"
end

desc "create plugin gems"
task :plugins do
  plugins.each do |spec|
    gem_file = "#{spec.name}-#{spec.version}.gem"
    
    Gem::Builder.new(spec).build
    verbose(true) {
      mv gem_file, "pkg/#{gem_file}"
    }

  end
end
