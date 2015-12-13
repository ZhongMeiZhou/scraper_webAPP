Dir.glob('./{helpers, forms}/*.rb').each { |file| require file }

require 'rake/testtask'

task :default => :spec

desc 'Run all tests'
Rake::TestTask.new(name = :spec) do |t|
  t.pattern = 'specs/*_spec.rb'
end
