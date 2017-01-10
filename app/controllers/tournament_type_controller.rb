class TournamentTypeController < ApplicationController
  def findAll
    render json: TournamentType.all
  end
end