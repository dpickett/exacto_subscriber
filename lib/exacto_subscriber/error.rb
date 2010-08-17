module Exacto
  class Error < Exception
    attr_reader :code, :messsage
    def initialize(code, msg)
      @code = code
      @message = msg
      super("Exacto Error: #{code} - #{msg}")
    end
    
    def self.from_response(response)
      if code = response["error"]
        raise new(code, response["error_description"])
      end
    end
  end
end