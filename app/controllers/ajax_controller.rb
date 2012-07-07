class AjaxController < ApplicationController
  layout false

  def index
    @json = {
      :id => Vote.order(:id).select(:id).to_a
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
