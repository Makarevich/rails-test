require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test "can insert positive" do
    rec = nil
    assert_nothing_raised do
      rec = Vote.create(:id => 100, :count => 256)
    end
    assert(rec.valid?)
  end

  test "can insert a record with negative count" do
    assert_raise(ActiveRecord::RecordInvalid) do
      Vote.create!(:id => 101, :count => -2)
    end
  end
end
