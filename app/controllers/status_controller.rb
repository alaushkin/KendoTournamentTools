class StatusController < ApplicationController
  def findAll
    render json: Status.all
  end
end