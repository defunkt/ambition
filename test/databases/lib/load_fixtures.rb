dirname = File.dirname(__FILE__)
%w(rubygems active_record active_record/version active_record/fixtures).each {|f| require f}
puts "  (ActiveRecord v#{ActiveRecord::VERSION::STRING})"
require File.join(dirname, 'activerecord_test_connector')

# setup the connection
ActiveRecordTestConnector.setup

# load all fixtures
fixture_path = File.join(dirname, '..', 'fixtures')
Fixtures.create_fixtures(fixture_path, tables = ActiveRecord::Base.connection.tables - %w(schema_info))

puts "Available models: #{Dir[fixture_path+'/*.rb'].map{|f|File.basename(f,'.rb')}.map(&:classify).to_sentence}"
