require 'rubygems'
require "configatron"
require "httparty"
require "nokogiri"

module Exacto
  def self.username=(user)
    configatron.exacto.username = user
  end
  
  def self.username
    configatron.exacto.username
  end
  
  def self.password=(password)
    configatron.exacto.password = password
  end
  
  def self.password
    configatron.exacto.password
  end
end

require "exacto_subscriber/ext/hacked_request"

require "exacto_subscriber/error"
require "exacto_subscriber/base"

require "exacto_subscriber/subscriber"

require "exacto_subscriber/unsubscription"
require "exacto_subscriber/list_unsubscription"
require "exacto_subscriber/master_list_unsubscription"
