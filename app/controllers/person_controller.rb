class PersonController < ApplicationController
  ##VIEWS
  def page_view
    @tournament_id = params[:tournament_id]
    @page = Person.includes(:tournament_persons)
                .where(tournament_persons: {:tournament_id => params[:tournament_id]})
                .references(:tournament_persons)
                .order('last_name asc, first_name asc, middle_name asc')
                .paginate(:page => params[:num], :per_page => params[:per_page])
    render 'persons/page'
  end

  def details_view
    @person = Person.find(params[:id])
    render 'persons/details'
  end

  def edit_view
    @person = Person.find(params[:id])
    render 'persons/edit'
  end

  def new_view
    @tournament_id = params[:tournament_id]
    render 'persons/new'
  end

  ##API

  def findAll
    render json: Person.all
  end

  def details
    person = Person.find(params[:id])
    render json: person.to_json(:include => [:level, :club])
  end

  def save
    person = Person.new(person_params)
    r = person.save
    if r == true
      redirect_to '/views/person/'+person.id.to_s
    else
      render json: {:error => person.errors.full_messages}
    end
  end

  def update
    record = Person.find(person_params[:id])
    r = record.update person_params
    if r == true
      redirect_to '/views/person/'+person.id.to_s
    else
      render json: {:error => person.errors.full_messages}
    end
  end

  def person_params
    params.require(:person).permit(:id, :rank, :sex, :first_name, :last_name, :middle_name, :club_id, :level_id, :birth_date, :phone, :email)
  end
end