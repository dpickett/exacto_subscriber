require 'spec_helper'

describe Exacto::ListUnsubscription do
  let(:list_id) { configatron.exacto.test_list_id }
  subject { Exacto::ListUnsubscription.find(list_id) }
  
  before(:each) do
    VCR.insert_cassette('list_unsubscriptions/find')
  end

  after(:each) do
    VCR.eject_cassette
  end
  
  it { should_not be_empty }
  
  it 'should have an unsubscription with a valid email' do
    subject.first.email_address.should_not be_nil
  end
end