%w( rubygems test/spec mocha redgreen English ).each { |f| require f }

$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'ambition'
