class ApplicationController < ActionController::Base
  protect_from_forgery

  @@FACEBOOK_CLIENT_ID = ''

  def index
    puts request.host_with_port
  end

  def login
    if session[:code] or params[:error]
      redirect_to index_path
      return
    end

    if params[:code]
      session[:code] = params[:code]
      redirect_to index_path
      return
    end

    redirect_to "https://www.facebook.com/dialog/oauth?client_id=#{@@FACEBOOK_CLIENT_ID}"+
      "&redirect_uri=#{login_url}"
  end
end
