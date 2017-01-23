class FightController < ApplicationController
  def details_view
    @fight = Fight.find(params[:fight_id])
    render 'fights/details'
  end

  def edit_view
    if !check_user
      return
    end
    @fight = Fight.find(params[:fight_id])
    @persons = Person.includes(:tournament_persons).where(tournament_persons: {:tournament_id => @fight.tournament_id})
                   .order('last_name asc, first_name asc, middle_name asc')
    render 'fights/edit'
  end

  def update
    if !check_user
      return
    end
  end

  def person_params
    params.require(:fight).permit(:id, :fight_state_id, :white_person_id, :red_person_id, :white_hits, :red_hits, :fight_time)
  end
end