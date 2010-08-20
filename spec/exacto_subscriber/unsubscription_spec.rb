require 'spec_helper'

describe Exacto::Unsubscription do
  subject do
    Exacto::Unsubscription.new(
      :email => "user@example.com",
      :unsubscribed_at => Time.now.to_s
    )
  end

  its(:email) { should_not be_nil }
  its(:unsubscribed_at) { should_not be_nil }
  its(:unsubscribed_at) { should be_kind_of(DateTime) }

  describe "finding unsubscriptions" do
    before(:each) do
      VCR.insert_cassette('unsubscriptions/find')
    end

    after(:each) do
      VCR.eject_cassette
    end

    subject do
      Exacto::Unsubscription.find(
        :start_date => DateTime.parse("8/1/2010"), 
        :end_date   => DateTime.parse("8/20/2010"))
    end

    it { should_not be_empty }
  end
end