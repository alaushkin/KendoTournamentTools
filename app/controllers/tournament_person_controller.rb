class TournamentPersonController < ApplicationController
  #permit_all_parameters = true

  def add_to_tournament
    if !user_signed_in?
      render json: current_user
      return
    end
    errors = []
    params[:persons].each do |person_id|
      record = TournamentPerson.new
      record[:person_id] = person_id
      record[:tournament_id] = params[:tournament_id]
      record.save
      if !record.errors.empty?
        errors.append record
      end
      end
      if !errors.empty?
        render json: errors
      else
        render text: 'SUCCESS'
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