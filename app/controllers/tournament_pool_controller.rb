class TournamentPoolController < ApplicationController
  def generate_view
    if !check_user
      return
    end
    @tournament_id = params[:@tournament_id]
    render 'tournament_pools/generate'
  end

  def generate
    persons = Person.includes(:tournament_persons)
                  .where(tournament_persons: {:tournament_id => params[:tournament_id]})
                  .references(:tournament_persons)
    for i in 1..params[:count]

    end
    redirect_to '/tournament-pool/?tournament_id='+params[:tournament_id].to_s
  end

  def pool_list_view
    if !check_user
      return
    end
    @pools = TournamentPool.where(:tournament_id => params[:tournament_id])
    render 'tournament_pools/pool_list'
  end

  def details_view
    @pool = TournamentPool.find(params[:pool_id])
    render 'tournament_pools/details'
  end

end