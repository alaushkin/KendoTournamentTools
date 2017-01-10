class PersonController < ApplicationController
  def findAll
    render json: Person.all
  end

  def details
    record = Person.find(params[:id])
    render json: record.to_json(:include => [:level, :club])
  end

  def save
    model = Person.new(person_params)
    r = model.save
    if r == true
      render json: {:id => model.id}
    else
      render json: {:error => model.errors.full_messages}
    end
  end

  def update
    model = Person.find(person_params[:id])
    r = t.update person_params
    if r == true
      render json: {:id => model.id}
    else
      render json: {:error => model.errors.full_messages}
    end
  end

  def person_params
    params.require(:person).permit(:id, :rank, :sex, :first_name, :last_name, :middle_name, :club_id, :level_id, :birth_date, :phone, :email)
  end
end