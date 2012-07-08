
require 'spec_helper'

describe AjaxController do
  fixtures :votes

  describe 'index' do
    #
    # TODO: imp all the freaking tests for JSON responses
    #

    it "index returns vote ids" do
      get :index
      #assigns(:json).should == Vote.select(:id).order(:id).to_a
    end
  end

  describe 'vote' do

    # TODO: test facebook authentication

    it "should increment an existing vote if logged in" do
      prev = Vote.order(:id).to_a

      session[:name] = 'Anonymous'

      get :vote, :id => 3

      prev.each do |p|
        Vote.find_by_id(p[:id]).count.should == p[:count] unless p[:id] == 3
        Vote.find_by_id(p[:id]).count.should == p[:count] + 1 if p[:id] == 3
      end

      #assigns(:json).should == Vote.order(:id).to_a
    end


    it "should not increment an existing vote if not logged in" do
      prev = Vote.order(:id).to_a

      session[:code] = nil
      session[:name] = nil

      get :vote, :id => 3

      prev.each do |p|
        Vote.find_by_id(p[:id]).count.should == p[:count]
      end

      #assigns(:json).should == Vote.order(:id).to_a
    end

    it "should not increment an unknown vote even if logged in" do
      prev = Vote.order(:id).to_a

      session[:name] = 'Anonymous'

      get :vote, :id => 100

      prev.each do |p|
        Vote.find_by_id(p[:id]).count.should == p[:count]
      end

      #assigns(:json).should == Vote.order(:id).to_a
    end
  end
end
