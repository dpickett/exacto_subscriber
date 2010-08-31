module Exacto
  class Subscriber < Exacto::Base 
    attr_reader :email_address, :subscriber_id
    attr_accessor :list_id, :status, :attributes
        
    def initialize(options = {})
      update_from_options(options)
    end
    
    def subscribe_to(list_id)
      @status = "active"
      @list_id = list_id
      if item = self.class.find_by_email_and_list_id(email_address, list_id)
        item.list_id = list_id
        item.status = @status
        item.attributes = attributes
        item.update
      else
        create
      end
      
      self
    end
    
    def unsubscribe_from(list_id)
      @list_id = list_id
      @status = "Unsubscribed"
      if item = self.class.find_by_email_and_list_id(email_address, list_id)
        item.list_id = list_id
        item.status = status
        item.attributes = attributes
        item.update
      else
        create
      end
      
      self
    end
    
    def create
      @status ||= "active"
      issue_request do |xml|
        xml.action "add"
        xml.search_type "listid"
        xml.search_value @list_id
        xml.search_value2 nil
        resource_xml(xml)
      end
    end
    
    def update
      result = issue_request do |xml|
        xml.action "edit"
        xml.search_type "listid"
        xml.search_value @list_id
        xml.search_value2 email_address
        resource_xml(xml)
        xml.update true
      end
    end

    def resource_xml(xml)
      xml.values do
        xml.email__address @email_address
        xml.status @status if @status
        (self.attributes || {}).each do |field, val|
          xml.send(field.to_s.gsub("_", "__"), val) 
        end
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
      @email_address  = options[:email_address]
      @status = options[:status]
      @subscriber_id = options[:subscriber_id]
      @list_id    = options[:list_id]
      @attributes = options[:attributes] || {}
    end
    
    def self.find_by_email_and_list_id(email_address, list_id)
      begin
        result = issue_request do |xml|
          xml.action "retrieve"
          xml.search_type "listid"
          xml.search_value list_id
          xml.search_value2 email_address
          xml.showChannelID nil
        end
      rescue Error => e
        if e.code == "1"
          result = nil
        else
          raise e
        end
      end
      
      result.nil? || result.empty? ? nil : new(normalize(result))
    end
    
    def self.system_name
      "subscriber"
    end
  end
end
