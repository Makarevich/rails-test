require 'spec_helper'

describe Vote do
  it "can insert positive" do
    rec = Vote.create(:id => 100, :count => 256)
    rec.should be_true
    rec.should be_valid
  end

  it "can not insert a record with negative count" do
    expect {
      Vote.create!(:id => 101, :count => -2)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
