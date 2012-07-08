class AjaxController < ApplicationController
  layout false

  def index
    if session[:code]
      # TODO: authenticate on facebook; set up :name
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

      render :json => Vote.order(:id).to_a
      return
    end

    render :json => { :error => true }
  end
end
