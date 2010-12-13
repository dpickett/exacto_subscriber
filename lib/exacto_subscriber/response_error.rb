module Exacto
  class ResponseError < Exception
    def initialize(response)
      super("Exacto Response Error: #{response.nil? || response == "" ? "response was blank" : response}")
    end
  end
end