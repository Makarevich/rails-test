
require 'spec_helper'

describe ApplicationController do
  describe 'login' do
    it 'should redirect to facebook oauth' do
      get :login
      response.redirect_url.should match(%r{^https://www\.facebook\.com/dialog/oauth\?client_id=.*\&redirect_uri=.*login})
    end

    it 'should store the facebook code in the session' do
      code = 'akjshdlkajhsdlkjhaskldjhklxcblzxhb'

      session[:code] = nil

      get :login, :code => code

      session[:code].should be(code)

      response.should redirect_to(index_path)
    end

    it 'should handle facebook auth error' do
      code = Object.new

      session[:code] = nil

      get :login, :code => code, :error => 'access_denied'

      session[:code].should be_nil

      response.should redirect_to(index_path)
    end

    it 'should not attempt to reauthenticate' do
      session[:code] = Object.new

      get :login

      response.should redirect_to(index_path)
    end
  end

  describe 'logout' do
    it 'should clear the session and redirect to index' do
      get :logout

      session[:code].should be_nil
      session[:name].should be_nil

      response.should redirect_to(index_path)
    end
  end
end

