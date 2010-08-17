module Exacto
  class Base
    include HTTParty
    default_params :qf => 'xml'
    base_uri 'https://www.exacttarget.com/api'
    
    protected
    def issue_request(&block)
      self.class.issue_request(&block)
    end
    
    def self.issue_request(&block)
      if block_given?
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.exacttarget do
            xml.authorization do
              xml.username Exacto.username
              xml.password Exacto.password
            end
            xml.system do
              xml.system_name system_name
              yield(xml)
            end
          end
        end
        
        resp = parse_response(post("/integrate.asp", :body => {:xml => builder.to_xml}))
      end
    end
    
    def self.parse_response(response)
      trimmed_response = response["exacttarget"]["system"][self.system_name]
      raise_errors_for(trimmed_response)
      trimmed_response
    end
    
    private
    def self.raise_errors_for(response)
      Error.from_response(response)
    end
  end
end