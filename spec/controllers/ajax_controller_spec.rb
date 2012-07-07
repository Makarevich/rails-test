
require 'spec_helper'

describe AjaxController do
  describe 'index' do
    fixtures :votes

    it "assigns json IDs" do
      get :index
      json = assigns(:json)
      json.should have_key(:id)
      json[:id].should be_a_kind_of(Array)
      json[:id].should == Vote.select(:id).order(:id).to_a
    end

  end
end
