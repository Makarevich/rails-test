require 'open-uri'

class AjaxController < ApplicationController
  layout false

  def index
    if session[:code]
      # TODO: authenticate on facebook; set up :name

      resp = open 'https://graph.facebook.com/oauth/access_token' +
        "?client_id=#{ApplicationController::get_facebook_client_id}" +
        "&client_secret=#{ApplicationController::get_facebook_secret}" +
        "&code=#{session[:code]}"

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
