$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'exacto_subscriber'
require 'spec'
require 'spec/autorun'

require 'vcr'
require 'cgi'

configatron.exacto.configure_from_yaml(File.join(File.dirname(__FILE__), 'exact_target_credentials.yml'))

VCR.config do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), 'cassettes')
  c.http_stubbing_library = :fakeweb
  c.default_cassette_options = { 
    :record => :new_episodes  
  }
end

# we must hack VCR to always use erb for secure parameters
module VCR
  alias_method :orig_insert_cassette, :insert_cassette
  def insert_cassette(*args)
    args << {} if args.size == 1
    args.last.merge!(:erb => {
      :username => configatron.exacto.username,
      :password => configatron.exacto.password,
      :list_id  => configatron.exacto.test_list_id.to_s
    })

    orig_insert_cassette(*args)
  end
end

Spec::Runner.configure do |config|
end
