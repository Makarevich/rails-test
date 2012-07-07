class AjaxController < ApplicationController
  layout false

  def index
    @json = Vote.order(:id).select(:id).to_a
    render 'json'
  end

  def vote
    v = Vote.find_by_id(params[:id])
    if v
      v.count = v.count + 1
      v.save
    end

    @json = Vote.order(:id).to_a
    render 'json'
  end
end
