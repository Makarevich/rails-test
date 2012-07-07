
require 'spec_helper'

describe AjaxController do
  describe 'index' do
    fixtures :votes

    it "index returns vote ids" do
      get :index
      #assigns(:json).should == Vote.select(:id).order(:id).to_a
    end

    it "vote increments an existing vote" do
      prev = Vote.order(:id).to_a

      get :vote, :id => 3

      prev.each do |p|
        Vote.find_by_id(p[:id]).count.should == p[:count] unless p[:id] == 3
        Vote.find_by_id(p[:id]).count.should == p[:count] + 1 if p[:id] == 3
      end

      #assigns(:json).should == Vote.order(:id).to_a
    end

    it "vote doesnot increment an unknown vote" do
      prev = Vote.order(:id).to_a

      get :vote, :id => 100

      prev.each do |p|
        Vote.find_by_id(p[:id]).count.should == p[:count]
      end

      #assigns(:json).should == Vote.order(:id).to_a
    end
  end
end
