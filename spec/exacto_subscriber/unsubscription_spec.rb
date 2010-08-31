require 'spec_helper'

describe Exacto::Unsubscription do
  subject do
    Exacto::Unsubscription.new(
      :email_address => "user@example.com",
      :unsubscribed_at => Time.now.to_s
    )
  end

  its(:email_address) { should_not be_nil }
  its(:unsubscribed_at) { should_not be_nil }
  its(:unsubscribed_at) { should be_kind_of(DateTime) }
end
