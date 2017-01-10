class TournamentPersonController < ApplicationController
  permit_all_parameters = true

  def add_to_tournament
    params[:persons].each do |person_id|
      record = TournamentPerson.new
      record[:person_id] = person_id
      record[:tournament_id] = params[:tournament_id]
      record.save
    end
    render text: "SUCCESS"
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
    res = ""
    # csv_text = request.body.read
    # rows = CSV.parse(csv_text, :headers => true)
    # rows.each do |row|
    #   res = res + row[:first_name]
    # end
    render text: res
  end

  # def tournament_person_params
  #   params.require(:persons)
  # end
end