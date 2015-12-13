require 'bundler/setup'
require 'active_support/json'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'jsonapionify'
puts *$:
puts JSONAPIonify::Autoload.unloaded
JSONAPIonify::Autoload.eager_load!
require 'active_support/core_ext/object/json'

Dir.glob(File.join __dir__, 'shared_contexts/**/*.rb').each { |f| require f }
