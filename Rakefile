require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

task :install do
  require 'bundler'
  begin
    Bundler.require
  rescue
    system 'bundle update'
  end
end

file 'db/test' do
  ruby 'bin/testdata.rb'
end

task :spec => [:install, 'db/test']
