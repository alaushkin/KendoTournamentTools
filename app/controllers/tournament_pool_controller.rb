class TournamentPoolController < ApplicationController
  def generate_view
    if !check_user
      return
    end
    if !check_pools params[:tournament_id]
      return
    end
    @tournament_id = params[:tournament_id]
    render 'tournament_pools/generate'
  end

  def generate
    if !check_user
      return
    end
    if !check_pools params[:pool][:tournament_id]
      return
    end
    persons = Person.includes(:tournament_persons)
                  .where(tournament_persons: {:tournament_id => params[:pool][:tournament_id]})
                  .references(:tournament_persons).order('club_id')
    pool_persons = []
    pool_fights = []
    pools = []
    names = ['A', 'B', 'C', 'D', 'E', 'F', 'G']
    count = Integer(params[:pool][:count]).to_i
    for i in 0...count
      pool_persons.append([])
      pool_fights.append([])
      pool = TournamentPool.new
      pool[:tournament_id] = params[:pool][:tournament_id]
      pool[:name] = names[i]
      pool.save
      pools.append pool
    end
    i = 0
    persons.each do |person|
      pool_persons[i].append(person)
      i = i+1
      if i >= count
        i=0
      end
    end
    for i in 0...count
      persons = pool_persons[i]
      fights = pool_fights[i]
      while true
        if persons.count <= 0
          break
        end
        rnd = persons.count-1 == 0 ? 0 : Random.rand(persons.count-1)
        white = persons[rnd]
        repeats = fights.select { |fight| (fight.white_person_id == white.id || fight.red_person_id==white.id) }
        if repeats.count>=2
          persons.delete(white)
        else
          sel = persons.select { |person| person.id!=white.id }
          if sel.count >0
            for j in 0...11
              rnd1 = sel.count-1 == 0 ? 0 : Random.rand(0...(sel.count-1))
              red = sel[rnd1]
              if sel.count >1
                rep_fights = fights.select {
                    |fight|
                  (fight.white_person_id == white.id && fight.red_person_id == red.id) || (fight.white_person_id == red.id && fight.red_person_id == white.id)
                }
                if rep_fights.empty?
                  break
                end
              end
            end
          else
            red = Person.new
          end
          red_repeats = fights.select { |fight| (fight.white_person_id == red.id || fight.red_person_id==red.id) }
          if red_repeats.count>=2
            persons.delete(red)
          else
            fight = Fight.new
            fight.tournament_pool_id = pools[i].id
            fight.tournament_id = params[:pool][:tournament_id]
            fight.white_person_id = white.id
            fight.red_person_id = red.id
            fight.fight_state_id=1
            fight.save
            fights.append fight
          end
        end
      end
    end
    redirect_to '/tournament-pool/'+params[:pool][:tournament_id].to_s+'/list'
  end

  def pool_list_view
    @pools = TournamentPool.where(:tournament_id => params[:tournament_id])
    @links = [ {:name => 'К турниру', :link => '/tournament/'+params[:tournament_id].to_s} ]
    render 'tournament_pools/pool_list'
  end

  def details_view
    @pool = TournamentPool.find(params[:pool_id])
    @links = [
        {:name => 'К турниру', :link => '/tournament/'+@pool.tournament_id.to_s},
        {:name => 'К списку пулов', :link => '/tournament-pool/'+@pool.tournament_id.to_s+'/list'}
    ]
    render 'tournament_pools/details'
  end

  def check_pools(tournament_id)
    pools = TournamentPool.where(:tournament_id => tournament_id)
    if !pools.empty?
      @message = 'Для данного турнира уже есть пулы'
      render 'errors/error'
      return false
    end
    return true
  end

end