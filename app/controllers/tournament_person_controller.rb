class TournamentPersonController < ApplicationController
  #permit_all_parameters = true
  def add_persons_view
    if !check_user
      return
    end
    @tournament_id = params[:tournament_id]
    @persons = Person.all.order('last_name asc, first_name asc, middle_name asc')
    @links = [{:name => 'Завести нового', :link => '/person/new'}]
    render 'tournament_persons/add_persons'
  end

  def import_persons_view
    if !check_user
      return
    end
    @tournament_id = params[:tournament_id]
    render 'tournament_persons/import'
  end

  def add_persons
    if !check_user
      return
    end
    errors = []
    tournament_persons = params[:tournament_persons]
    persons = tournament_persons[:persons].delete_if { |x| x.empty? }
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
      @message = errors
      render 'errors/error'
    else
      redirect_to '/tournament/'+tournament_persons[:tournament_id].to_s
    end
  end

  def remove_person
    if !check_user
      return
    end
    record = TournamentPerson.where(:person_id => params[:person_id], :tournament_id => params[:tournament_id]).first
    TournamentPerson.destroy(record[:id])
    redirect_to '/tournament/'+params[:tournament_id].to_s
  end

  def persons_by_tournament
    record = TournamentPerson.where(:tournament_id => params[:tournament_id]).order('last_name asc, first_name asc, middle_name asc')
    render json: record.to_json(:include => :person)
  end

  def import_persons
    if !check_user
      return
    end
    file =params[:persons][:csv_file].read.force_encoding('windows-1251')
    csv = CSV.parse(file.encode('utf-8'), :headers => true, :col_sep => ';');
    csv.each do |row|
      add_or_create(row, params[:persons][:tournament_id])
    end
    redirect_to '/tournament/'+params[:persons][:tournament_id].to_s
  end

  def add_or_create(row, tournament_id)
    filter = {}
    if !row['last_name'].nil?
      filter[:last_name] = row['last_name']
    end
    if !row['first_name'].nil?
      filter[:first_name] = row['first_name']
    end
    if !row['middle_name'].nil?
      filter[:middle_name] = row['middle_name']
    end
    persons = Person.where(filter)
    tournament_person = TournamentPerson.new
    if persons.count == 1
      tournament_person[:person_id] = persons[0].id
      tournament_person[:tournament_id] = tournament_id
    end
    if persons.count == 0
      person = Person.new
      person[:first_name] = row['first_name']
      person[:last_name] = row['last_name']
      person[:middle_name] = row['middle_name']
      person[:birth_date] = row['birth_date']
      person[:phone] = row['phone']
      person[:email] = row['email']
      level = Level.where(:name => row['level']).first
      person.level_id = level.id
      club = Club.where(:name => row['club']).first
      if club.nil?
        club = Club.new(:name => row['club'])
        club.save
      end
      person.club_id = club.id
      person.sex = row['sex'] == 'М'
      person.save
      tournament_person[:person_id] = person.id
      tournament_person[:tournament_id] = tournament_id
    end
    tournament_person.save
  end
end