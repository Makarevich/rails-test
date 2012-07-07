class AjaxController < ApplicationController
  layout false

  def index
    render :json => Vote.order(:id).select(:id).to_a
  end

  def vote
    v = Vote.find_by_id(params[:id])
    if v
      v.count = v.count + 1
      v.save
    end

    render :json => Vote.order(:id).to_a
  end
end
