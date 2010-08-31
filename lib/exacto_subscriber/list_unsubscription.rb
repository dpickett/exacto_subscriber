module Exacto
  class ListUnsubscription < Unsubscription
    def self.request_system_name
      "tracking-channel"
    end
    
    def self.find(list_id)
      response = issue_request("list") do |xml|
        xml.action "retrieve_sub"
        xml.search_type "listid"
        xml.search_value list_id
        xml.search_status "Unsubscribed"
      end
      
      response = [response] if response.is_a?(Hash) && !response.empty?
      response.collect do |i|
        new(normalize(i))
      end
    end
    
    def self.response_system_name
      "subscriber"
    end
    
    def self.trim_response(response)
      super["list"]["subscribers"]
    end
    
    def self.request_system_name
      "tracking-channel"
    end
    
    def self.response_system_name
      "subscriber"
    end
  end
end