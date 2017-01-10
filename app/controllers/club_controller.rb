class ClubController < ApplicationController
  def findAll
    render json: Club.all
  end
end