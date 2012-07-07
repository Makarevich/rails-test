class AjaxController < ApplicationController
  layout false

  def index
    @json = {
      :name => 'index',
      :other => 100,
    }
    render 'json'
  end

  def vote
    @json = {
      :name => 'vote',
      :other => 321,
    }
    render 'json'
  end
end
