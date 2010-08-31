require "cgi"

class HackedRequest < HTTParty::Request
  def body
    CGI.unescape(super)
  end
end