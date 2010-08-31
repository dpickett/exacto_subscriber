module Exacto
  class MasterListUnsubscription < Unsubscription
    def self.find(start_date, end_date)
      response = issue_request("tracking") do |xml|
        xml.action "retrieve"
        xml.sub_action "masterunsub"
        xml.search_type ""
        xml.search_value ""
        xml.daterange do
          xml.startdate format_date_for_request(start_date)
          xml.enddate   format_date_for_request(end_date)
        end
      end

      response = [response] if response.is_a?(Hash) && !response.empty?
      response.collect do |i|
        new(normalize(i))
      end
    end 
    
    def self.trim_response(response)
      super(response)["tracking"]["masterunsub"]
    end
    
    def self.request_system_name
      "tracking"
    end
    
    def self.response_system_name
      "subscriber"
    end
  end
end