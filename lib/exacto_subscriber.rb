require 'rubygems'
require "configatron"
require "httparty"
require "nokogiri"

module Exacto
  def self.user=(user)
    configatron.exacto.user = user
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

require "exacto_subscriber/error"
require "exacto_subscriber/base"

require "exacto_subscriber/subscriber"
