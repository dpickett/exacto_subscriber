module Exacto
  class Unsubscription < Base
    attr_reader :email_address, :unsubscribed_at, :status
    def initialize(options = {})
      @email_address = options[:email_address]
      if options[:unsubscribed_at]
        @unsubscribed_at = DateTime.parse(options[:unsubscribed_at])
      end
    end
    
    def response_system_name
      "subscriber"
    end
  end
end