class TournamentController < ApplicationController
  def page
    t = Tournament.find(3)
    t.status
    render json: t
  end

  def details
    t = Tournament.find(params[:id])
    render json: t.to_json(:include => [:status, :tournament_type])
  end

  def save
    t = Tournament.new(JSON.parse(request.body))
    t.status
    render text: t.save
  end
end