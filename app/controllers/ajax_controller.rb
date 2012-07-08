require 'net/http'

class AjaxController < ApplicationController
  layout false

  def index
    if session[:code]
      # TODO: authenticate on facebook; set up :name

      uri = URI 'https://graph.facebook.com/oauth/access_token' +
        "?client_id=#{ApplicationController::get_facebook_client_id}" +
        "&client_secret=#{ApplicationController::get_facebook_secret}" +
        "&code=#{session[:code]}" +
        "&redirect_uri=#{index_url}"

      puts uri

      resp = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
        ggg = Net::HTTP::Get.new uri.request_uri
        puts ggg.inspect
        http.request ggg
      end

      puts resp.inspect

      session[:name] = 'Anonymous'
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
end
