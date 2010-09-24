module Exacto
  class Base
    include HTTParty
    default_params :qf => 'xml'
    base_uri 'https://www.exacttarget.com/api'
    
    protected
    def issue_request(&block)
      self.class.issue_request(&block)
    end
    
    def self.issue_request(system_name = nil, &block)
      if block_given?
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.exacttarget do
            xml.authorization do
              xml.username Exacto.username
              xml.password Exacto.password
            end
            xml.system do
              xml.system_name system_name || request_system_name
              yield(xml)
            end
          end
        end
        
        resp = parse_response(post("/integrate.asp", 
          :body => {:xml => builder.to_xml}, 
          :timeout => Exacto.default_timeout))
      end
    end
    
    def self.parse_response(response)
      raise_errors_for(response["exacttarget"]["system"][self.request_system_name])
      trimmed_response = trim_response(response)

      trimmed_response = trimmed_response[self.response_system_name] if trimmed_response
      trimmed_response || {}
    end
    
    def self.normalize(resulting_hash)
      new_hash = {}
      resulting_hash.each do |key, value|
        if key =~ /subid/
          new_hash[:subscriber_id] = value
        elsif key =~ /Email\_\_Address/
          new_hash[:email_address] = value
        else
          new_hash[key.gsub(/\_\_/, "_").gsub(/id/, "_id").downcase.to_sym] = value
        end
      end
      
      new_hash
    end
    
    def self.format_date_for_request(date)
      date.strftime("%m/%d/%Y").gsub(/^0/, "").gsub(/\/0/, "\/")
    end
    
    def self.trim_response(response)
      response["exacttarget"]["system"]
    end
    
    def self.request_system_name
      system_name
    end
    
    def self.response_system_name
      system_name
    end
    
    private
    def self.raise_errors_for(response)
      Error.from_response(response)
    end
    
    #we need to hack HTTParty to not encode params so inject a hacked request object in this method
    def perform_request(http_method, path, options) #:nodoc:
      options = default_options.dup.merge(options)
      process_cookies(options)
      HackedRequest.new(http_method, path, options).perform
    end
  end
end