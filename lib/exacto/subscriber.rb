module Exacto
  class Subscriber < Exacto::Base 
    attr_reader :email, :attrs, :subscriber_id
    attr_accessor :list_id, :status
        
    def initialize(options = {})
      update_from_options(options)
    end
    
    def subscribe_to(list_id)
      @list_id = list_id
      if item = self.class.find_by_email_and_list_id(email, list_id)
        item.list_id = list_id
        item.update
      else
        create
      end
    end
    
    def unsubscribe_from(list_id)
      @list_id = list_id
      @status = "Unsubscribed"
      if item = self.class.find_by_email_and_list_id(email, list_id)
        item.list_id = list_id
        item.status = status
        item.update
      else
        create
      end
    end
    
    def create
      issue_request do |xml|
        xml.action "add"
        xml.search_type "listid"
        xml.search_value @list_id
        xml.search_value2 nil
        xml.values do
          xml.email__address @email
          xml.status @status || "active"
        end
      end
    end
    
    def update
      result = issue_request do |xml|
        xml.action "edit"
        xml.search_type "listid"
        xml.search_value @list_id
        xml.search_value2 email
        xml.values do 
          xml.status @status || "active"
        end
        xml.update true
      end
    end
    
    def destroy
      issue_request do |xml|
        xml.action "delete"
        xml.search_type "subid"
        xml.search_value subscriber_id
      end
    end
    
    def update_from_options(options)
      @email  = options[:email]
      @status = options[:status]
      @subscriber_id = options[:subscriber_id]
    end
    
    def self.find_by_email_and_list_id(email, list_id)
      begin
        result = issue_request do |xml|
          xml.action "retrieve"
          xml.search_type "listid"
          xml.search_value list_id
          xml.search_value2 email
          xml.showChannelID nil
        end
      rescue Error => e
        if e.code == "1"
          result = nil
        else
          raise e
        end
      end
      
      result.nil? ? nil : new(normalize(result))
    end
    
    def self.normalize(resulting_hash)
      new_hash = {}
      resulting_hash.each do |key, value|
        if key =~ /subid/
          new_hash[:subscriber_id] = value
        elsif key =~ /Email\_\_Address/
          new_hash[:email] = value
        else
          new_hash[key.gsub(/\_\_/, "_").gsub(/id/, "_id").downcase.to_sym] = value
        end
      end
      
      new_hash
    end
    
    def self.system_name
      "subscriber"
    end
  end
end