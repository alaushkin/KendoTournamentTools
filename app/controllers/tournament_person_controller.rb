class TournamentPersonController < ApplicationController
  #permit_all_parameters = true
  def add_persons_view
    @tournament_id = params[:tournament_id]
    render 'tournament_persons/add_persons'
  end

  def add_persons
    errors = []
    tournament_persons = params[:tournament_persons]
    persons = tournament_persons[:persons].delete_if{|x| x.empty?}
    persons.each do |person_id|
      record = TournamentPerson.new
      record[:person_id] = person_id
      record[:tournament_id] = tournament_persons[:tournament_id]
      record.save
      if !record.errors.empty?
        errors.append record
      end
      end
      if !errors.empty?
        render json: errors
      else
        redirect_to '/views/tournament/'+tournament_persons[:tournament_id].to_s
      end
  end

  def remove_person
    record = TournamentPerson.where(:person_id => params[:person_id], :tournament_id => params[:tournament_id]).first
    TournamentPerson.destroy(record[:id])
    render text: "SUCCESS"
  end

  def persons_by_tournament
     record = TournamentPerson.where(:tournament_id => params[:tournament_id])
     render json: record.to_json(:include => :person)
  end

  def import_persons
    csv = CSV.parse(request.body.read, :headers => true, :col_sep => ';');
    # headers = csv[0]
    # res = []
    # csv.each do |row|
    #   i = 0;
    #   map = {}
    #   row.each do |str|
    #     map[headers[i]] = str
    #     i = i+1
    #   end
    #   res.append(map)
    # end
    render text: request.body.read
  end

end