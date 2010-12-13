require 'spec_helper'

describe Exacto::Subscriber do
  let(:list_id) { configatron.exacto.test_list_id }
  let(:email_address) { "user3@example.com" }
  
  subject do
    Exacto::Subscriber.new(
      :email_address => email_address, 
      :attributes    => {"First__Name" => "John", "Last__Name" => "Smith"})
  end
  
  describe 'subscriptions' do
    before(:each) do
      VCR.insert_cassette('subscribers/subscribe')
      result = subject.class.find_by_email_and_list_id(email_address, list_id)
      result.destroy if result
    end

    after(:each) do
      VCR.eject_cassette
    end

    it 'should successfully subscribe someone that does not exist' do
      subject.subscribe_to(list_id).should_not be_nil
    end
    
    it 'should successfully subscribe someone that already exists' do
      second_attempt = nil
      subject.subscribe_to(list_id).should_not be_nil
      lambda { second_attempt = subject.subscribe_to(list_id) }.should_not raise_error
      second_attempt.should_not be_nil
    end
  end
  
  describe "unsubscribing" do
    before(:each) do
      VCR.insert_cassette('subscribers/unsubscribe')
      result = subject.class.find_by_email_and_list_id(email_address, list_id)
      result.destroy if result
    end

    after(:each) do
      VCR.eject_cassette
    end
    
    it 'should successfully unsubscribe someone that does not exist' do
      subject.unsubscribe_from(list_id).should_not be_nil
    end
    
    it 'should successfully unsubscribe someone that does exist' do
      second_attempt = nil
      subject.unsubscribe_from(list_id).should_not be_nil
      lambda { second_attempt = subject.unsubscribe_from(list_id) }.should_not raise_error
      second_attempt.should_not be_nil
    end
  end
  
  describe 'finding a subscriber by email and list id' do
    before(:each) do
      VCR.insert_cassette('subscribers/find_by_email_and_list_id')
      Exacto::Subscriber.new(
        :email_address => email_address, 
        :attributes    => {"First__Name" => "John", "Last__Name" => "Smith"}).subscribe_to(list_id)
    end

    after(:each) do
      subscriber.destroy
      VCR.eject_cassette
    end

    let(:subscriber){ Exacto::Subscriber.find_by_email_and_list_id(email_address, list_id) }
    subject { subscriber }
    
    it { should_not be_nil }
    its(:email_address) { should_not be_nil }
    its(:subscriber_id) { should_not be_nil }
  end
  
  describe "error conditions" do
    it 'should raise an exacto error if Exact Target returns an error' do
      fake_response(:post, "https://www.exacttarget.com/api/integrate.asp?qf=xml", 
        read_mock_response("exact_target_supplied_response_error"))
      lambda { subject.subscribe_to(list_id) }.should raise_error(Exacto::Error)
    end
    it "should raise a response error if Exact Target does not return an intended response" do
      fake_response(:post, "https://www.exacttarget.com/api/integrate.asp?qf=xml",
        read_mock_response("blank_response"))
    end
  end  
  
  def fake_response(method, uri, body)
    FakeWeb.register_uri(method, uri, :body => body, :content_type => "text/xml")
  end
  
  MOCK_RESPONSE_DIR = File.join(File.dirname(__FILE__), "../mock_responses")
  def read_mock_response(base_file_name)
    File.read(File.join(MOCK_RESPONSE_DIR, "#{base_file_name}.xml"))
  end
end
