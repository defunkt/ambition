require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Version = '0.5.0'

module Rake::TaskManager
  def delete_task(task_class, args, &block)
    task_name, deps = resolve_args(args)
    @tasks.delete(task_class.scope_name(@scope, task_name).to_s)
  end
end
class Rake::Task
  def self.delete_task(args, &block) Rake.application.delete_task(self, args, &block) end
end
def delete_task(args, &block) Rake::Task.delete_task(args, &block) end

begin
  require 'rubygems'
  gem 'echoe', '>=2.7'
  ENV['RUBY_FLAGS'] = ""
  require 'echoe'

  Echoe.new('ambition', Version) do |p|
    p.project = 'err'
    p.summary        = "Ambition builds yer API calls from plain jane Ruby."
    p.description    = "Ambition builds yer API calls from plain jane Ruby."
    p.url            = "http://errtheblog.com/"
    p.author         = 'Chris Wanstrath'
    p.email          = "chris@ozmm.org"
    p.dependencies << 'ParseTree =2.0.1'
    p.dependencies << 'ruby2ruby =1.1.7'
    p.test_pattern = 'test/*_test.rb'
    p.ignore_pattern = /^(\.git|site|adapters).+/
  end

rescue LoadError 
  puts "Not doing any of the Echoe gemmy stuff, because you don't have the specified gem versions"
end

delete_task :test
delete_task :install_gem

Rake::TestTask.new('test') do |t|
  t.pattern = 'test/*_test.rb'
end

Rake::TestTask.new('test:adapters') do |t|
  t.pattern = 'adapters/*/test/*_test.rb'
end

Dir['adapters/*'].each do |adapter|
  adapter = adapter.split('/').last
  Rake::TestTask.new("test:adapters:#{adapter.sub('ambitious_','')}") do |t|
    t.pattern = "adapters/#{adapter}/test/*_test.rb"
  end
end

desc 'Default: run unit tests.'
task :default => :test

desc 'Generate RDoc documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  files = ['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main     = "README" 
  rdoc.title    = "ambition"
  rdoc.template = File.exists?(t="/Users/chris/ruby/projects/err/rock/template.rb") ? t : "/var/www/rock/template.rb"
  rdoc.rdoc_dir = 'doc' 
  rdoc.options << '--inline-source'
end

desc 'Generate coverage reports'
task :rcov do
  `rcov -e gems test/*_test.rb`
  puts 'Generated coverage reports.'
end

desc 'Install as a gem'
task :install_gem do
  puts `rake package && gem install pkg/ambition-#{Version}.gem`
end
