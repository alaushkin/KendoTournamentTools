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
    fight = Fight.find(person_params[:id])
    fight.update person_params
    redirect_to '/fight/'+fight.id.to_s
  end

  def grid_view
    @final = Fight.where({:tournament_id => params[:tournament_id], :parent_id => nil, :tournament_pool_id => nil}).first
    render 'fights/grid'
  end

  def generate_grid
    if !check_user
      return
    end
    unfinished_count = TournamentPool.joins(:fights).where('fights.fight_state_id != ? and tournament_pools.tournament_id=?', 3, params[:tournament_id]).count
    if unfinished_count > 0
      @message = 'Есть незавершенные поединки в пулах'
      render 'errors/error'
      return
    end
    pools = TournamentPool.where(:tournament_id => params[:tournament_id])

    exit_pool = []
    pools.each do |pool|
      winners = {}
      pool.fights.each do |fight|
        if !fight.winner_id.nil?
          if winners[fight.winner_id].nil?
            winners[fight.winner_id] = 1
          else
            winners[fight.winner_id] = winners[fight.winner_id] + 1
          end
        end
      end
      winners = winners.sort_by { |k, v| v }
      winners[0, pool.fights.count/2].each { |k| exit_pool.append(k[0]) }
    end
    first_level_fights = []
    while exit_pool.count>0 do
      fight = Fight.new
      fight.tournament_id = params[:tournament_id]
      fight.fight_state_id=1
      white = exit_pool[exit_pool.count-1 ==0 ? 0 : rand(0...(exit_pool.count-1))]
      fight.white_person_id=white
      exit_pool.delete(white)
      if exit_pool.count>0
        red = exit_pool[exit_pool.count-1 ==0 ? 0 : rand(0...(exit_pool.count-1))]
        fight.red_person_id=red
        exit_pool.delete(red)
      end
      fight.save
      first_level_fights.append fight
    end
    make_grid(first_level_fights)
    redirect_to '/fight/grid?tournament_id='+params[:tournament_id].to_s
  end

  def make_grid(level_fights)
    if level_fights.count <=1
      return
    end
    i = 0;
    new_level = []
    while i<level_fights.count
      fight = Fight.new
      fight.tournament_id = level_fights[i].tournament_id
      fight.fight_state_id=1
      fight.save
      level_fights[i].update({:parent_id => fight.id})
      if i+1 <level_fights.count
        level_fights[i+1].update({:parent_id => fight.id})
      end
      new_level.append fight
      i += 2
    end
    make_grid(new_level)
  end

  def person_params
    params.require(:fight).permit(:id, :fight_state_id, :white_person_id, :red_person_id, :white_hits, :red_hits, :fight_time, :winner_id)
  end
end