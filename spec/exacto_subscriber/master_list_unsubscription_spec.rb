require 'spec_helper'

describe Exacto::MasterListUnsubscription do
  describe "finding existing unsubscriptions" do
    before(:each) do
      VCR.insert_cassette('master_list_unsubscriptions/find_existing', :record => :all)
    end

    after(:each) do
      VCR.eject_cassette
    end

    subject do
      Exacto::MasterListUnsubscription.find(DateTime.parse("08/01/2010"), DateTime.parse("09/01/2010"))
    end

    it { should_not be_empty }
    it 'should have a valid unsubscriber (someone with an email)' do
      subject.first.email_address.should_not be_blank
    end
  end
  
  describe "finding an empty set of unsubscriptions" do
    before(:each) do
      VCR.insert_cassette('master_list_unsubscriptions/find_nonexistent', :record => :all)
    end

    after(:each) do
      VCR.eject_cassette
    end

    subject do
      Exacto::MasterListUnsubscription.find(DateTime.parse("08/01/2010"), DateTime.parse("08/01/2010"))
    end

    it { should be_empty }
  end    
end