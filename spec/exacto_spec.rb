require 'spec_helper'

describe Exacto do
  subject { Exacto }
  
  its(:username) { should_not be_nil }
  its(:password) { should_not be_nil }
end