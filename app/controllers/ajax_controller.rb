require 'net/http'
require 'cgi'

class AjaxController < ApplicationController
  layout false

  def index
    if session[:code]
      # TODO: authenticate on facebook; set up :name

      resp = call_https 'https://graph.facebook.com/oauth/access_token' +
        "?client_id=#{ApplicationController::get_facebook_client_id}" +
        "&client_secret=#{ApplicationController::get_facebook_secret}" +
        "&code=#{session[:code]}" +
        "&redirect_uri=#{CGI::escape login_url}"

      #puts resp.inspect
      #puts resp.read_body.inspect

      if resp.kind_of? Net::HTTPSuccess
        access_token = CGI::parse(resp.read_body)["access_token"][0]
      else
        puts "<resp failed!!!>"
        render :json => { :error => true }
        return
      end

      #puts 'Token:', access_token.inspect

      resp = call_https 'https://graph.facebook.com/me' +
        "?access_token=#{access_token}"

      #puts resp.inspect
      #puts resp.read_body.inspect

      if resp.kind_of? Net::HTTPSuccess
        session[:name] = ActiveSupport::JSON::decode(resp.read_body)["name"]
      else
        puts "<resp failed!!!>"
        render :json => { :error => true }
        return
      end
    end

    if session[:name]
      render :json => {
        :name => session[:name],
        :data => Vote.order(:id).select(:id).to_a
      }
      return
    end

    render :json => { :error => true }
  end

  def vote
    if session[:name]
      v = Vote.find_by_id(params[:id])
      if v
        v.count = v.count + 1
        v.save
      end

      render :json => {
        :data => Vote.order(:id).to_a
      }
      return
    end

    render :json => { :error => true }
  
  end

  private 

  def call_https(uri)
    uri = URI uri
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
      http.request Net::HTTP::Get.new uri.request_uri
    end
  end
end
